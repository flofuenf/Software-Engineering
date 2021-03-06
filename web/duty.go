package web

import (
	"log"

	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) receiveDuty(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		log.Println(err)
	}
	log.Println(com)
	err = s.graph.InsertDuty(&com.Duties[0])
	if err != nil {
		log.Println(err)
	}

	err = s.graph.AddDutyByID(com.GUID, com.Duties[0].GUID)
	if err != nil {
		lib.Jsonify(c, "", 0, err)
	}

	lib.Jsonify(c, com.Duties[0].GUID, 1, err)
}

func (s *Server) getDuties(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		log.Println(err)
	}

	duties, count, err := s.graph.FetchDutiesByID(com.GUID)
	if err != nil {
		log.Println(err)
	}

	lib.Jsonify(c, duties, count, err)
}

func (s *Server) setDutyDone(c *gin.Context) {
	var duty data.Duty
	err := c.BindJSON(&duty)
	if err != nil {
		log.Println(err)
	}

	duty, count, err := s.graph.SetDutyAsDone(duty.GUID)

	lib.Jsonify(c, duty, count, err)
}

func (s *Server) setDuty(c *gin.Context) {
	var duty data.Duty

	err := c.BindJSON(&duty)
	if err != nil {
		log.Println(err)
	}
	log.Println(duty.RotationList[0].Commune)
	guid, count, err := s.graph.UpdateDuty(&duty)
	if err != nil {
		guid = ""
	}

	lib.Jsonify(c, guid, count, err)
}

func (s *Server) deleteDuty(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		log.Println(err)
	}

	err = s.graph.DeleteDuty(&com)
	if err != nil {
		com.Duties[0].GUID = ""
	}
	lib.Jsonify(c, com.Duties[0].GUID, 1, err)
}
