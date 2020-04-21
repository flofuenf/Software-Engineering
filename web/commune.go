package web

import (
	"git.rrdc.de/lib/lg"
	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) receiveCommune(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		lg.PrintErr(err)
	}

	err = s.graph.AddCommune(&com)
	lib.Jsonify(c, com.GUID, 1, err)
}
