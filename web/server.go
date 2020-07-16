package web

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/contrib/static"
	"github.com/gin-gonic/gin"
	"github.com/pkg/errors"
	"gitlab.com/flofuenf/communeism/auth"
	"gitlab.com/flofuenf/communeism/data"
)

// Server describes the structure of the HTTP Server
type Server struct {
	graph   *data.DGraph
	auth    *auth.Database
	router  *gin.Engine
	secure  *gin.RouterGroup
	address string
}

// SetupServer declares the HTTP Server for further use
func SetupServer(graph *data.DGraph, auth *auth.Database, port int) *Server {
	server := &Server{
		graph:   graph,
		auth:    auth,
		router:  gin.Default(),
		secure:  nil,
		address: ":" + strconv.Itoa(port),
	}
	server.router.Use(corsMiddleware()).Use(static.Serve("/", static.LocalFile("./static", true)))
	server.secure = server.router.Group("api")
	server.secure.Use(corsMiddleware()).Use(authMiddleware())
	server.registerEndpoints()
	server.registerSecureEndpoints()
	return server
}

// Run is starting the HTTP Server
func (s *Server) Run() error {
	err := s.router.Run(s.address)
	return errors.WithStack(err)
}

func (s *Server) registerEndpoints() {
	s.router.POST("/register", s.register)
	s.router.POST("/login", s.login)
	s.router.POST("token/refresh", s.refresh)
}

func (s *Server) registerSecureEndpoints() {
	s.secure.POST("/communeGet", s.getCommune)
	s.secure.POST("/commune", s.receiveCommune)
	s.secure.POST("/joinCommune", s.joinCommune)

	s.secure.POST("/userGet", s.getUser)

	s.secure.POST("/duty", s.receiveDuty)
	s.secure.POST("/dutyGet", s.getDuties)
	s.secure.POST("/dutySet", s.setDuty)
	s.secure.POST("/dutyDone", s.setDutyDone)
	s.secure.POST("/dutyDelete", s.deleteDuty)

	s.secure.POST("/consumable", s.receiveConsumable)
	s.secure.POST("/consumableGet", s.getConsumables)
	s.secure.POST("/consumableSwitch", s.switchConsumableBought)
	s.secure.POST("/consumableSet", s.setConsumable)
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

func authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		err := TokenValid(c.Request)
		if err != nil {
			c.JSON(http.StatusUnauthorized, err.Error())
			c.Abort()
			return
		}
		c.Next()
	}
}
