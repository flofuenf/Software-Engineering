package web

import (
	"log"

	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) receiveCommune(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		log.Println(err)
	}

	err = s.graph.InsertCommune(&com)
	lib.Jsonify(c, com.GUID, 1, err)
}

func (s *Server) getCommune(c *gin.Context) {
	var input data.Commune
	err := c.BindJSON(&input)
	if err != nil {
		log.Println(err)
	}

	com, err := s.graph.FetchCommuneByID(input.GUID)
	if err != nil {
		log.Print(err)
	}
	lib.Jsonify(c, com, 1, err)
}

func (s *Server) joinCommune(c *gin.Context) {
	var input data.Commune
	err := c.BindJSON(&input)
	if err != nil {
		log.Println(err)
	}
	err = s.graph.JoinCommuneByID(input.GUID, input.Members[0].GUID)
	if err != nil {
		log.Println(err)
	}
	lib.Jsonify(c, nil, 1, err)
}

func (s *Server) leaveCommune(c *gin.Context) {
	var input data.Commune
	err := c.BindJSON(&input)
	if err != nil {
		log.Println(err)
	}
	err = s.graph.LeaveCommune(&input)
	if err != nil {
		log.Println(err)
	}

	lib.Jsonify(c, nil, 1, err)
}
