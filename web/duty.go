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

func (s *Server) getDuties(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		lg.PrintErr(err)
	}

	duties, count, err := s.graph.FetchDutiesByID(com.GUID)
	if err != nil {
		lg.PrintErr(err)
	}

	lib.Jsonify(c, duties, count, err)
}

func (s *Server) setDutyDone(c *gin.Context) {
	var duty data.Duty
	err := c.BindJSON(&duty)
	if err != nil {
		lg.PrintErr(err)
	}

	duty, count, err := s.graph.SetDutyAsDone(duty.GUID)

	lib.Jsonify(c, duty, count, err)
}
