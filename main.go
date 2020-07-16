package main

import (
	"flag"
	"log"
	"os"

	"github.com/pkg/errors"
	"gitlab.com/flofuenf/communeism/auth"
	"gitlab.com/flofuenf/communeism/data"
	"gitlab.com/flofuenf/communeism/web"
)

var (
	port       = flag.Int("port", 8000, "Port for your GO Endpoint")
	graphDB    = flag.String("graph", "192.168.99.100:9082", "Graph Database address")
	dbServer   = flag.String("db", "dwarftech.de:3306", "SQL server address")
	dbUser     = flag.String("dbUser", "web524", "MSSQL user")
	dbPass     = flag.String("dbPass", "HgeRUI_18ooC", "MSSQL password")
	dbName     = flag.String("dbName", "web524_db5", "MSSQL database")
	accessKey  = flag.String("accSecret", "secret0", "JWT Access Key secret")
	refreshKey = flag.String("refSecret", "secret1", "JWT Refresh Key secret")
)

func main() {
	flag.Parse()

	if err := setEnvVariables(); err != nil {
		log.Fatal(err)
	}

	if err := run(); err != nil {
		log.Fatal(err)
	}
}

func setEnvVariables() error {
	if err := os.Setenv("ACCESS_SECRET", *accessKey); err != nil {
		return err
	}
	if err := os.Setenv("REFRESH_SECRET", *refreshKey); err != nil {
		return err
	}
	return nil
}

func run() error {
	graph, err := data.SetupDgraph(*graphDB)
	if err != nil {
		return errors.WithStack(err)
	}
	defer graph.Close()

	userBase, err := auth.New(*dbUser, *dbPass, *dbServer, *dbName)
	if err != nil {
		return errors.WithStack(err)
	}
	defer userBase.Close()

	server := web.SetupServer(graph, userBase, *port)
	return server.Run()
}
