package web

import (
	"log"

	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) receiveConsumable(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		log.Println(err)
	}

	err = s.graph.InsertConsumable(&com.Consumables[0])
	if err != nil {
		log.Println(err)
	}

	err = s.graph.AddConsumableByID(com.GUID, com.Consumables[0].GUID)

	lib.Jsonify(c, com.Consumables[0].GUID, 1, err)
}

func (s *Server) getConsumables(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		log.Println(err)
	}

	consumables, count, err := s.graph.FetchConsumablesByID(com.GUID)
	if err != nil {
		log.Println(err)
	}

	lib.Jsonify(c, consumables, count, err)
}

func (s *Server) switchConsumableBought(c *gin.Context) {
	var con data.Consumable
	err := c.BindJSON(&con)
	if err != nil {
		log.Println(err)
	}

	con, count, err := s.graph.SwitchConsumableAsBought(con.GUID)

	lib.Jsonify(c, con, count, err)
}

func (s *Server) setConsumable(c *gin.Context) {
	var con data.Consumable
	err := c.BindJSON(&con)
	if err != nil {
		log.Println(err)
	}

	guid, count, err := s.graph.UpdateConsumable(&con)
	if err != nil {
		guid = ""
	}

	lib.Jsonify(c, guid, count, err)
}

func (s *Server) deleteConsumable(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		log.Println(err)
	}

	err = s.graph.DeleteConsumable(&com)
	if err != nil {
		com.Consumables[0].GUID = ""
	}
	lib.Jsonify(c, com.Consumables[0].GUID, 1, err)
}
