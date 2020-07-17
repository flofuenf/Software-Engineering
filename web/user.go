package web

import (
	"log"

	"github.com/pkg/errors"

	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) getUser(c *gin.Context) {
	var input data.User
	err := c.BindJSON(&input)
	if err != nil {
		log.Println(err)
	}
	usr, err := s.graph.FetchUserByID(input.GUID)
	if err != nil {
		log.Println(err)
	}
	log.Println(usr)
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
