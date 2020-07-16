package main

import (
	"flag"
	"log"

	"github.com/pkg/errors"

	"gitlab.com/flofuenf/communeism/auth"

	"gitlab.com/flofuenf/communeism/web"

	"gitlab.com/flofuenf/communeism/data"
)

var (
	port     = flag.Int("port", 8000, "Port for your GO Endpoint")
	graphDB  = flag.String("graph", "192.168.99.100:9082", "Your SQL Database Name")
	dbServer = flag.String("sqlsrv", "dwarftech.de:3306", "MSSQL server address")
	dbUser   = flag.String("sqluser", "web524", "MSSQL user")
	dbPass   = flag.String("sqlpass", "HgeRUI_18ooC", "MSSQL password")
	dbName   = flag.String("sqldb", "web524_db5", "MSSQL database")
)

func main() {
	flag.Parse()

	if err := run(); err != nil {
		log.Fatal(err)
	}
}

func run() error {
	graph, err := data.SetupGraphClient(*graphDB)
	if err != nil {
		return errors.WithStack(err)
	}
	defer graph.Close()

	userBase, err := auth.New(*dbUser, *dbPass, *dbServer, *dbName)
	if err != nil {
		return err
	}
	defer userBase.Close()

	server := web.SetupServer(graph, userBase, *port)
	return server.Run()
}
