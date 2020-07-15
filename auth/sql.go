package auth

import (
	"fmt"

	"git.rrdc.de/lib/lg"

	"gitlab.com/flofuenf/communeism/data"

	"github.com/google/uuid"

	"database/sql"

	"git.rrdc.de/lib/errors"
	_ "github.com/go-sql-driver/mysql" // golint
)

var (
	fetchUser  *sql.Stmt
	insertUser *sql.Stmt
	updateUser *sql.Stmt
)

// Database describes an Database Object
type Database struct {
	Conn *sql.DB
}

type User struct {
	Uid      string `json:"uid"`
	Mail     string `json:"username"`
	PassHash string `json:"password"`
	UserID   string `json:"user_id"`
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
func (s *Database) Close() error {
	return errors.WithStack(s.Conn.Close())
}

func (s *Database) GetUser(user *data.Auth) error {
	var (
		err error
	)

	if fetchUser == nil {
		if fetchUser, err = s.Conn.Prepare(`SELECT * FROM auth WHERE mail = ?`); err != nil {
			return errors.WithStack(err)
		}
	}
	row := fetchUser.QueryRow(user.Mail)
	if err = row.Scan(&user.GUID, &user.Mail, &user.Pass, &user.UserID); err != nil {
		lg.Println(err)
		lg.Println("Row Scann error")
		return errors.WithStack(err)
	}
	return err
}

func (s *Database) InsertUser(user *data.Auth) error {
	var err error
	user.GUID = uuid.New().String()
	if insertUser == nil {
		if insertUser, err = s.Conn.Prepare(`INSERT INTO auth (uid, mail, pw_hash, user_id) VALUES (?,?,?,?)`); err != nil {
			return errors.WithStack(err)
		}
	}

	_, err = insertUser.Exec(user.GUID, user.Mail, user.Pass, user.UserID)
	if err != nil {
		return errors.WithStack(err)
	}
	return nil
}

func (s *Database) UpdateUser(user *User) error {
	var err error
	if updateUser == nil {
		if updateUser, err = s.Conn.Prepare(`UPDATE auth SET mail = ?, pw_hash = ?, user_id = ? WHERE uid = ?`); err != nil {
			return errors.WithStack(err)
		}
	}

	resp, err := updateUser.Exec(user.Mail, user.PassHash, user.UserID, user.Uid)
	if err != nil {
		return errors.WithStack(err)
	}
	count, err := resp.RowsAffected()
	if err != nil {
		return errors.WithStack(err)
	}
	if count == 0 {
		return errors.WithStack(errors.New("User not found"))
	}

	return nil
}
