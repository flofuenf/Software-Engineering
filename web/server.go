package web

import (
	"strconv"

	"git.rrdc.de/lib/lg"

	"git.rrdc.de/lib/errors"
	"gitlab.com/flofuenf/communeism/data"

	"github.com/gin-gonic/gin"
)

// Server describes the structure of the HTTP Server
type Server struct {
	sql     *data.SQL
	router  *gin.Engine
	address string
}

// SetupServer declares the HTTP Server for further use
func SetupServer(sql *data.SQL, port int) *Server {
	server := &Server{
		sql:     sql,
		router:  gin.Default(),
		address: ":" + strconv.Itoa(port),
	}
	server.registerEndpoints()
	return server
}

// Run is starting the HTTP Server
func (s *Server) Run() error {
	err := s.router.Run(s.address)
	return errors.WithStack(err)
}

func (s *Server) registerEndpoints() {
	lg.Println("Endpoints")
}
