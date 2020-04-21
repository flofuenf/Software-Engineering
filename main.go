package main

import (
	"flag"

	"git.rrdc.de/lib/errors"
	"gitlab.com/flofuenf/communeism/web"

	"gitlab.com/flofuenf/communeism/data"

	"git.rrdc.de/lib/lg"
)

var (
	port      = flag.Int("port", 8000, "Port for your GO Endpoint")
	dbName    = flag.String("dbName", "web524_db5", "Your SQL Database Name")
	dbAddress = flag.String("dbAddress", "www.dwarftech.de:3306", "Your SQL Database Address")
	dbUser    = flag.String("dbUser", "web524", "Your SQL Database User")
	dbPass    = flag.String("dbPass", "HgeRUI_18ooC", "Your SQL Database Password")
)

func main() {
	flag.Parse()

	if err := run(); err != nil {
		lg.PrintErr(err, lg.PanicLevel)
	}
}

func run() error {
	sql, err := data.SetupSQL(*dbUser, *dbPass, *dbAddress, *dbName)
	if err != nil {
		return errors.WithStack(err)
	}
	defer sql.Close()

	server := web.SetupServer(sql, *port)
	return server.Run()
}
