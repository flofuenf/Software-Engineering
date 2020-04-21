package data

import "time"

// AddUser adds a User to Database
func (s *DGraph) AddUser(user *User) error {
	user.DGraphType = "User"
	user.GUID = "_:" + user.DGraphType
	user.Created = time.Now().Unix()
	uids, err := s.mutateDB(user)
	user.GUID = uids[user.DGraphType]
	return err
}
