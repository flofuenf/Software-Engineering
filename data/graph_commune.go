package data

import (
	"log"
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
	log.Println(guid)
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
							commune
						}
        			}
				}`

	err := s.queryDBWithVars(query, &comWrap, vars)
	if err != nil {
		return nil, errors.WithStack(err)
	}

	return comWrap.Root[0], nil
}

// LeaveCommune lets a user leave a commune
func (s *DGraph) LeaveCommune(com *Commune) error {
	var (
		err      error
		userList []User
	)
	userGUID := com.Members[0].GUID
	communeFromDB, err := s.FetchCommuneByID(com.GUID)
	if err != nil {
		return errors.WithStack(err)
	}
	duties, _, err := s.FetchDutiesByID(com.GUID)
	if err != nil {
		return errors.WithStack(err)
	}
	consumables, _, err := s.FetchConsumablesByID(com.GUID)
	if err != nil {
		return errors.WithStack(err)
	}

	if duties != nil {
		for _, duty := range duties.([]Duty) {
			update := false
			userList = []User{}
			for _, member := range duty.RotationList {
				if member.GUID == userGUID {
					update = true
					continue
				}
				userList = append(userList, member)
			}
			if update {
				if len(duty.RotationList) == 1 {
					err = s.DeleteDuty(&Commune{GUID: com.GUID, Duties: []Duty{
						duty,
					}})
					continue
				}
				duty.RotationList = userList
				_, _, err = s.UpdateDuty(&duty)
			}
		}
		if err != nil {
			return errors.WithStack(err)
		}
	}

	if consumables != nil {
		userList = []User{}
		for _, consumable := range consumables.([]Consumable) {
			update := false
			userList = []User{}
			for _, member := range consumable.RotationList {
				if member.GUID == userGUID {
					update = true
					continue
				}
				userList = append(userList, member)
			}
			if update {
				if len(consumable.RotationList) == 1 {
					err = s.DeleteConsumable(&Commune{GUID: com.GUID, Consumables: []Consumable{
						consumable,
					}})
					continue
				}
				consumable.RotationList = userList
				_, _, err = s.UpdateConsumable(&consumable)
			}
		}
		if err != nil {
			return errors.WithStack(err)
		}
	}

	userList = []User{}
	for _, member := range communeFromDB.(Commune).Members {
		if member.GUID != userGUID {
			userList = append(userList, member)
		}
	}

	newCom := communeFromDB.(Commune)
	newCom.Members = userList

	err = s.deletePredicateDB(com.GUID, "members")
	if err != nil {
		return errors.WithStack(err)
	}

	_, err = s.mutateDB(newCom)
	if err != nil {
		return errors.WithStack(err)
	}

	err = s.mutateSinglePredString(com.Members[0].GUID, "commune", "")
	if err != nil {
		return errors.WithStack(err)
	}

	return err
}

// JoinCommuneByID sets the Commune for a User
func (s *DGraph) JoinCommuneByID(comID string, usrID string) error {
	err := s.mutateSinglePredString(usrID, "commune", comID)
	if err != nil {
		return errors.WithStack(err)
	}
	err = s.mutateSinglePred(comID, "members", usrID)
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
