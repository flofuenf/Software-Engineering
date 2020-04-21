package main

import (
	"flag"

	"git.rrdc.de/lib/errors"
	"gitlab.com/flofuenf/communeism/web"

	"gitlab.com/flofuenf/communeism/data"

	"git.rrdc.de/lib/lg"
)

var (
	port    = flag.Int("port", 8000, "Port for your GO Endpoint")
	graphDB = flag.String("graph", "192.168.99.100:9082", "Your SQL Database Name")
)

func main() {
	flag.Parse()

	if err := run(); err != nil {
		lg.PrintErr(err, lg.PanicLevel)
	}
}

func run() error {
	graph, err := data.SetupGraphClient(*graphDB)
	if err != nil {
		return errors.WithStack(err)
	}
	defer graph.Close()

	server := web.SetupServer(graph, *port)
	return server.Run()
}
