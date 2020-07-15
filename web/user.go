package web

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/pkg/errors"

	"git.rrdc.de/lib/lg"
	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) getUser(c *gin.Context) {
	var input data.User
	err := c.BindJSON(&input)
	if err != nil {
		lg.PrintErr(err)
	}
	usr, err := s.graph.FetchUserByID(input.GUID)
	if err != nil {
		lg.PrintErr(err)
	}
	lg.Println(usr)
	lib.Jsonify(c, usr, 1, err)

}

func (s *Server) addUser(auth *data.Auth) error {
	var usr = data.User{
		Name:  auth.Name,
		Birth: auth.Birth,
	}
	err := s.graph.AddUser(&usr)
	if err != nil {
		return errors.WithStack(err)
	}
	auth.UserID = usr.GUID
	return nil
}

// func (s *Server) login(c *gin.Context) {
// 	var auth data.Auth
// 	err := c.BindJSON(&auth)
// 	if err != nil {
// 		lg.PrintErr(err)
// 	}
// }

// func (s *Server) newUser(c *gin.Context) {
// 	var auth data.Auth
// 	var usr data.User
// 	err := c.BindJSON(&auth)
// 	if err != nil {
// 		lg.PrintErr(err)
// 		c.JSON(http.StatusUnprocessableEntity, "Error")
// 		c.Next()
// 	}
// 	err = sendRegistration(&auth)
// 	if err != nil {
// 		lg.PrintErr(err)
// 		c.JSON(http.StatusUnprocessableEntity, "Error")
// 		c.Next()
// 	}
// 	err = s.addUser(&auth, &usr)
// 	if err != nil {
// 		lg.PrintErr(err)
// 		c.JSON(http.StatusUnprocessableEntity, "Error")
// 		c.Next()
// 	}
//
// 	err = updateUserBase(usr.GUID, auth.GUID)
// 	if err != nil {
// 		lg.PrintErr(err)
// 		c.JSON(http.StatusUnprocessableEntity, "Error")
// 		c.Next()
// 	}
//
// 	c.JSON(http.StatusOK, gin.H{"success": true})
// }

func updateUserBase(userGuid, authGuid string) error {
	url := "http://localhost:8080/update"
	jsonStr := []byte(fmt.Sprintf("{\"uid\": \"%s\",\"user_id\": \"%s\"}", authGuid, userGuid))
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonStr))
	if err != nil {
		return errors.WithStack(err)
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return errors.WithStack(err)
	}
	if resp.StatusCode != 200 {
		return errors.WithStack(errors.New("Failed Updating"))
	}
	return nil
}

func sendRegistration(auth *data.Auth) error {
	url := "http://localhost:8080/register"
	jsonStr := []byte(fmt.Sprintf("{\"username\": \"%s\",\"password\": \"%s\"}", auth.Mail, auth.Pass))
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonStr))
	if err != nil {
		return errors.WithStack(err)
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return errors.WithStack(err)
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	err = json.Unmarshal(body, auth)
	if err != nil {
		return errors.WithStack(err)
	}
	return nil
}
