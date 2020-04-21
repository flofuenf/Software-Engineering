package web

import (
	"git.rrdc.de/lib/lg"
	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) receiveDuty(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		lg.PrintErr(err)
	}

	err = s.graph.InsertDuty(&com.Duties[0])
	if err != nil {
		lg.PrintErr(err)
	}

	err = s.graph.AddDutyByID(com.GUID, com.Duties[0].GUID)

	lib.Jsonify(c, com.Duties[0].GUID, 1, err)
}
