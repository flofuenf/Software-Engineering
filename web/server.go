package web

import (
	"strconv"

	"git.rrdc.de/lib/errors"
	"gitlab.com/flofuenf/communeism/data"

	"github.com/gin-gonic/gin"
)

// Server describes the structure of the HTTP Server
type Server struct {
	graph   *data.DGraph
	router  *gin.Engine
	address string
}

// SetupServer declares the HTTP Server for further use
func SetupServer(graph *data.DGraph, port int) *Server {
	server := &Server{
		graph:   graph,
		router:  gin.Default(),
		address: ":" + strconv.Itoa(port),
	}
	server.router.Use(corsMiddleware())
	server.registerEndpoints()
	return server
}

// Run is starting the HTTP Server
func (s *Server) Run() error {
	err := s.router.Run(s.address)
	return errors.WithStack(err)
}

func (s *Server) registerEndpoints() {
	s.router.POST("/communeGet", s.getCommune)
	s.router.POST("/commune", s.receiveCommune)
	s.router.POST("/joinCommune", s.joinCommune)

	s.router.POST("/user", s.receiveUser)
	s.router.GET("/user", s.getUser)

	s.router.POST("/duty", s.receiveDuty)
}

func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers",
			"Content-Type, Content-Length, Accept-Encoding, "+
				"X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	}
}
