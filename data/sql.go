package data

import (
	"fmt"

	"git.rrdc.de/lib/lg"

	"database/sql"

	"git.rrdc.de/lib/errors"
	_ "github.com/go-sql-driver/mysql" // golint
)

// SQL describes an SQL Connection
type SQL struct {
	conn *sql.DB
}

// SetupSQL sets up your SQL Connection
func SetupSQL(user, pass, address, dbName string) (*SQL, error) {
	source := fmt.Sprintf("%s:%s@tcp(%s)/%s", user, pass, address, dbName)
	conn, err := sql.Open("mysql", source)
	if err != nil {
		return nil, errors.WithStack(err)
	}
	conn.SetMaxIdleConns(0)
	if err = conn.Ping(); err != nil {
		return nil, errors.WithStack(err)
	}
	return &SQL{
		conn: conn,
	}, nil
}

// Close closes the Database connection
func (s *SQL) Close() {
	err := s.conn.Close()
	lg.PrintErr(err)
}
