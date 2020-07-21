package data

import (
	"log"
	"time"

	"github.com/pkg/errors"
)

const dutyType = "Duty"

// InsertDuty adds a Duty to Database
func (s *DGraph) InsertDuty(duty *Duty) error {
	duty.DGraphType = dutyType
	duty.GUID = "_:" + duty.DGraphType
	duty.Created = time.Now().Unix()
	duty.Changed = time.Now().Unix()
	duty.LastDone = 0
	duty.RotationIndex = 0
	uids, err := s.mutateDB(duty)
	duty.GUID = uids[duty.DGraphType]
	return err
}

// DeleteDuty deletes one Duty by GUID
func (s *DGraph) DeleteDuty(com *Commune) error {
	err := s.deletePredicateDB(com.Duties[0].GUID, "rotationList")
	if err != nil {
		return errors.WithStack(err)
	}
	err = s.deleteObjectDB(com.GUID, "duties", com.Duties[0].GUID)
	if err == nil {
		err = s.deleteEdgeDB(com.Duties[0].GUID)
	}
	return errors.WithStack(err)
}

// UpdateDuty updates a Duty
func (s *DGraph) UpdateDuty(duty *Duty) (string, int, error) {
	duty.DGraphType = dutyType
	duty.Changed = time.Now().Unix()
	log.Println(duty.RotationList[0].Commune)
	// err := s.deletePredicateDB(duty.GUID, "rotationList")
	// if err == nil {
	// 	_, err := s.mutateDB(duty)
	// 	if err != nil {
	// 		return "", 0, errors.WithStack(err)
	// 	}
	// }
	return duty.GUID, 1, nil
}

// SetDutyAsDone sets a Duty as done and recalculates the timestamps
func (s *DGraph) SetDutyAsDone(guid string) (Duty, int, error) {
	duty, _, err := s.FetchSingleDutyByID(guid)
	if err != nil {
		return Duty{}, 0, errors.WithStack(err)
	}
	duty.LastDone = time.Now().Unix()
	duty.NextDone += duty.RotationTime
	if int(duty.RotationIndex) != len(duty.RotationList)-1 {
		duty.RotationIndex++
	} else {
		duty.RotationIndex = 0
	}

	duty.DGraphType = dutyType
	_, err = s.mutateDB(duty)
	if err != nil {
		return Duty{}, 0, errors.WithStack(err)
	}

	return duty, 1, nil
}

// FetchSingleDutyByID fetches a single Duty by ID
func (s *DGraph) FetchSingleDutyByID(guid string) (Duty, int, error) {
	var (
		dutyWrap DutyWrapper
		vars     = make(map[string]string)
	)

	vars["$guid"] = guid
	query := `query query($guid: string){
					query(func: uid($guid))@filter(type(Duty)){
            				uid
            				created
            				changed
            				name
							description
							lastDone
							nextDone
							rotationTime
							rotationIndex
							rotationList{
								uid
								name
								commune
							}
        			}
				}`

	err := s.queryDBWithVars(query, &dutyWrap, vars)
	if err != nil {
		return Duty{}, 0, errors.WithStack(err)
	}

	return dutyWrap.Root[0], len(dutyWrap.Root), nil
}

// FetchDutiesByID queries a commune by it's ID
func (s *DGraph) FetchDutiesByID(guid string) (interface{}, int, error) {
	var (
		comWrap CommuneWrapper
		vars    = make(map[string]string)
	)

	vars["$guid"] = guid
	query := `query query($guid: string){
					query(func: uid($guid))@filter(type(Commune)){
          				duties{
            				uid
            				created
            				changed
            				name
							description
							lastDone
							nextDone
							rotationTime
							rotationIndex
							rotationList{
								uid
								name
								commune
							}
          				}
        			}
				}`

	err := s.queryDBWithVars(query, &comWrap, vars)
	if err != nil {
		return nil, 0, errors.WithStack(err)
	}

	if len(comWrap.Root) < 1 {
		return nil, 0, nil
	}

	return comWrap.Root[0].Duties, len(comWrap.Root[0].Duties), nil
}
