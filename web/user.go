package web

import (
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
	lib.Jsonify(c, usr, 1, err)

}

func (s *Server) receiveUser(c *gin.Context) {
	var usr data.User
	err := c.BindJSON(&usr)
	if err != nil {
		lg.PrintErr(err)
	}

	err = s.graph.AddUser(&usr)
	lib.Jsonify(c, usr.GUID, 1, err)
}
