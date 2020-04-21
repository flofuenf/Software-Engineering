package web

import (
	"git.rrdc.de/lib/lg"
	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) receiveUser(c *gin.Context) {
	var usr data.User
	err := c.BindJSON(&usr)
	if err != nil {
		lg.PrintErr(err)
	}

	err = s.graph.AddUser(&usr)
	lib.Jsonify(c, usr.GUID, 1, err)
}
