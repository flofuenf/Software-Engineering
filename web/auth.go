package web

import (
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"

	"gitlab.com/flofuenf/communeism/data"

	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/lib"

	"github.com/dgrijalva/jwt-go"
)

func TokenValid(r *http.Request) error {
	token, err := verifyToken(r)
	if err != nil {
		return err
	}
	if _, ok := token.Claims.(jwt.Claims); !ok && !token.Valid {
		return err
	}
	return nil
}

func verifyToken(r *http.Request) (*jwt.Token, error) {
	tokenString := extractToken(r)
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Make sure that the token method conform to "SigningMethodHMAC"
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(os.Getenv("ACCESS_SECRET")), nil
	})
	if err != nil {
		return nil, err
	}
	return token, nil
}

func extractToken(r *http.Request) string {
	bearToken := r.Header.Get("Authorization")
	strArr := strings.Split(bearToken, " ")
	if len(strArr) == 2 {
		return strArr[1]
	}
	return ""
}

func (s *Server) login(c *gin.Context) {
	var auth data.Auth
	if err := c.ShouldBindJSON(&auth); err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{
			"success": false,
			"message": "Invalid Request",
		})
		return
	}

	pass := auth.Pass

	err := s.auth.GetUser(&auth)
	if err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{
			"success": false,
			"message": "No user found with this combination",
		})
		return
	}

	if !lib.ComparePasswords(auth.Pass, []byte(pass)) {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "Wrong Password",
		})
		return
	}

	token, err := CreateToken(auth.UserID)
	if err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{
			"success": false,
			"message": "Token Failure",
		})
		return
	}
	response := gin.H{
		"user_id":       token.UserID,
		"access_token":  token.AccessToken,
		"refresh_token": token.RefreshToken,
		"atExp":         token.AtExpires,
		"rtExp":         token.RtExpires,
	}
	c.JSON(http.StatusOK, response)
}

func CreateToken(userID string) (*data.TokenDetails, error) {
	td := &data.TokenDetails{}
	td.UserID = userID
	td.AtExpires = time.Now().Add(time.Minute * 15).Unix()
	td.RtExpires = time.Now().Add(time.Hour * 72).Unix()

	var err error
	// Creating Access Token
	// TODO: Secret as ENV!!!
	os.Setenv("ACCESS_SECRET", "secret")
	atClaims := jwt.MapClaims{}
	atClaims["user_id"] = userID
	atClaims["exp"] = td.AtExpires
	at := jwt.NewWithClaims(jwt.SigningMethodHS256, atClaims)
	td.AccessToken, err = at.SignedString([]byte(os.Getenv("ACCESS_SECRET")))
	if err != nil {
		return nil, err
	}

	// //Creating Refresh Token
	// // TODO: Secret as ENV!!!
	os.Setenv("REFRESH_SECRET", "secret")
	rtClaims := jwt.MapClaims{}
	rtClaims["user_id"] = userID
	rtClaims["exp"] = td.RtExpires
	rt := jwt.NewWithClaims(jwt.SigningMethodHS256, rtClaims)
	td.RefreshToken, err = rt.SignedString([]byte(os.Getenv("REFRESH_SECRET")))
	if err != nil {
		return nil, err
	}
	return td, nil
}

func (s *Server) register(c *gin.Context) {
	var auth data.Auth
	if err := c.ShouldBindJSON(&auth); err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{
			"success": false,
			"message": "Invalid Request",
		})
		return
	}

	err := s.addUser(&auth)
	if err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{
			"success": false,
			"message": "Error Creating User",
		})
		return
	}

	auth.Pass = lib.HashAndSalt(auth.Pass)
	err = s.auth.InsertUser(&auth)
	if err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{
			"success": false,
			"message": "Registration Error",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"uid": auth.UserID,
	})
}

func (s *Server) refresh(c *gin.Context) {
	var tokenReq data.TokenDetails
	if err := c.Bind(&tokenReq); err != nil {
		c.JSON(http.StatusUnprocessableEntity, "Internal Error")
	}

	token, err := jwt.Parse(tokenReq.RefreshToken, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte("secret"), nil
	})
	if err != nil {
		c.JSON(http.StatusUnauthorized, "Non valid Refresh Token")
		return
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		userID := fmt.Sprintf("%s", claims["user_id"])
		check, err := s.auth.CheckUserID(userID)
		if err != nil || !check {
			c.JSON(http.StatusUnauthorized, "Token error, no user found")
			return
		}
		newTokenPair, err := CreateToken(userID)
		if err != nil {
			c.JSON(http.StatusUnprocessableEntity, "Internal Error")
			return
		}

		c.JSON(http.StatusOK, newTokenPair)
	}
}
