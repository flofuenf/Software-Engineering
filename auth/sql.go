package auth

import (
	"fmt"
	"log"

	"database/sql"

	_ "github.com/go-sql-driver/mysql" // golint
	"github.com/pkg/errors"
)

// Database describes an Database Object
type Database struct {
	Conn *sql.DB
}

// New returns a new NewDatabase Client
func New(user, pass, address, dbName string) (*Database, error) {
	source := fmt.Sprintf("%s:%s@tcp(%s)/%s", user, pass, address, dbName)
	conn, err := sql.Open("mysql", source)
	if err != nil {
		return nil, errors.WithStack(err)
	}
	conn.SetMaxIdleConns(0)
	if err = conn.Ping(); err != nil {
		return nil, errors.WithStack(err)
	}
	return &Database{
		Conn: conn,
	}, nil
}

// Close closes the Database connection
func (s *Database) Close() {
	log.Println(errors.WithStack(s.Conn.Close()))
}
