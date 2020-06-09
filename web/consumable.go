package web

import (
	"git.rrdc.de/lib/lg"
	"github.com/gin-gonic/gin"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/lib"
)

func (s *Server) receiveConsumable(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		lg.PrintErr(err)
	}

	err = s.graph.InsertConsumable(&com.Consumables[0])
	if err != nil {
		lg.PrintErr(err)
	}

	err = s.graph.AddConsumableByID(com.GUID, com.Consumables[0].GUID)

	lib.Jsonify(c, com.Consumables[0].GUID, 1, err)
}

func (s *Server) getConsumables(c *gin.Context) {
	var com data.Commune
	err := c.BindJSON(&com)
	if err != nil {
		lg.PrintErr(err)
	}

	consumables, count, err := s.graph.FetchConsumablesByID(com.GUID)
	if err != nil {
		lg.PrintErr(err)
	}

	lib.Jsonify(c, consumables, count, err)
}

func (s *Server) switchConsumableBought(c *gin.Context) {
	var con data.Consumable
	err := c.BindJSON(&con)
	if err != nil {
		lg.PrintErr(err)
	}

	con, count, err := s.graph.SwitchConsumableAsBought(con.GUID)

	lib.Jsonify(c, con, count, err)
}
