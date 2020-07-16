package data

import (
	"time"

	"github.com/pkg/errors"
)

// AddUser adds a User to Database
func (s *DGraph) AddUser(user *User) error {
	user.DGraphType = "User"
	user.GUID = "_:" + user.DGraphType
	user.Created = time.Now().Unix()
	uids, err := s.mutateDB(user)
	user.GUID = uids[user.DGraphType]
	return err
}

// FetchUserByID queries a commune by it's ID
func (s *DGraph) FetchUserByID(guid string) (interface{}, error) {
	var (
		usrWrap UserWrapper
		vars    = make(map[string]string)
	)

	vars["$guid"] = guid
	query := `query query($guid: string){
					query(func: uid($guid))@filter(type(User)){
          				uid
          				name
          				birth
						commune
        			}
				}`

	err := s.queryDBWithVars(query, &usrWrap, vars)
	if err != nil {
		return nil, errors.WithStack(err)
	}

	return usrWrap.Root[0], nil
}
