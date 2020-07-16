package auth

import (
	"database/sql"

	"github.com/google/uuid"
	"github.com/pkg/errors"
	"gitlab.com/flofuenf/communeism/data"
)

var (
	fetchUser   *sql.Stmt
	checkUserID *sql.Stmt
	insertUser  *sql.Stmt
	updateUser  *sql.Stmt
)

// GetUser fetches a User by his mail
func (s *Database) GetUser(user *data.Auth) error {
	var err error

	if fetchUser == nil {
		if fetchUser, err = s.Conn.Prepare(`SELECT * FROM auth WHERE mail = ?`); err != nil {
			return errors.WithStack(err)
		}
	}
	row := fetchUser.QueryRow(user.Mail)
	if err := row.Scan(&user.GUID, &user.Mail, &user.Pass, &user.UserID); err != nil {
		return errors.WithStack(err)
	}
	return err
}

// CheckUserID checks if a user with a given userID exists
func (s *Database) CheckUserID(userID string) (bool, error) {
	var (
		err  error
		user data.Auth
	)

	if checkUserID == nil {
		if checkUserID, err = s.Conn.Prepare(`SELECT * FROM auth WHERE user_id = ?`); err != nil {
			return false, errors.WithStack(err)
		}
	}
	row := checkUserID.QueryRow(userID)
	if err = row.Scan(&user.GUID, &user.Mail, &user.Pass, &user.UserID); err != nil {
		return false, errors.WithStack(err)
	}

	if user.UserID != userID {
		return false, errors.WithStack(errors.New("User not found"))
	}
	return true, err
}

// InsertUser inserts a new User
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

// UpdateUser updates a whole user
func (s *Database) UpdateUser(user *data.Auth) error {
	var err error
	if updateUser == nil {
		if updateUser, err = s.Conn.Prepare(`UPDATE auth SET mail = ?, pw_hash = ?, user_id = ? WHERE uid = ?`); err != nil {
			return errors.WithStack(err)
		}
	}

	res, err := updateUser.Exec(user.Mail, user.Pass, user.UserID, user.GUID)
	if err != nil {
		return errors.WithStack(err)
	}
	count, err := res.RowsAffected()
	if err != nil {
		return errors.WithStack(err)
	}
	if count == 0 {
		return errors.WithStack(errors.New("User not found"))
	}

	return nil
}
