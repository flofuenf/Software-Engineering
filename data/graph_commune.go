package data

import (
	"time"

	"github.com/pkg/errors"
)

// InsertCommune adds a Commune to Database
func (s *DGraph) InsertCommune(commune *Commune) error {
	err := s.AddAddress(&commune.Address)
	if err != nil {
		return errors.WithStack(err)
	}

	commune.DGraphType = "Commune"
	commune.GUID = "_:" + commune.DGraphType
	commune.Created = time.Now().Unix()
	uids, err := s.mutateDB(commune)
	commune.GUID = uids[commune.DGraphType]
	return err
}

// FetchCommuneByID queries a commune by it's ID
func (s *DGraph) FetchCommuneByID(guid string) (interface{}, error) {
	var (
		comWrap CommuneWrapper
		vars    = make(map[string]string)
	)

	vars["$guid"] = guid
	query := `query query($guid: string){
					query(func: uid($guid))@filter(type(Commune)){
          				uid
          				name
          				description
          				address{
            				uid
            				street
            				city
            				zip
          				}
						members{
							uid
							name
							birth
							created
						}
        			}
				}`

	err := s.queryDBWithVars(query, &comWrap, vars)
	if err != nil {
		return nil, errors.WithStack(err)
	}

	return comWrap.Root[0], nil
}

// JoinCommuneByID sets the Commune for a User
func (s *DGraph) JoinCommuneByID(comID string, usrID string) error {
	err := s.mutateSinglePred(comID, "members", usrID)
	return errors.WithStack(err)
}

// AddDutyByID sets the Duty for a Commune
func (s *DGraph) AddDutyByID(comID string, dutID string) error {
	err := s.mutateSinglePred(comID, "duties", dutID)
	return errors.WithStack(err)
}

// AddConsumableByID sets the Consumable for a Commune
func (s *DGraph) AddConsumableByID(comID string, conID string) error {
	err := s.mutateSinglePred(comID, "consumables", conID)
	return errors.WithStack(err)
}
