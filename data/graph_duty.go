package data

import (
	"time"

	"git.rrdc.de/lib/lg"

	"git.rrdc.de/lib/errors"
)

// InsertDuty adds a Duty to Database
func (s *DGraph) InsertDuty(duty *Duty) error {
	duty.DGraphType = "Duty"
	duty.GUID = "_:" + duty.DGraphType
	duty.Created = time.Now().Unix()
	duty.Changed = time.Now().Unix()
	duty.LastDone = 0
	duty.RotationIndex = 0
	duty.NextDone = time.Now().Unix() + duty.RotationTime
	uids, err := s.mutateDB(duty)
	duty.GUID = uids[duty.DGraphType]
	return err
}

// UpdateDuty updates a Duty
func (s *DGraph) UpdateDuty(duty *Duty) (string, int, error) {
	duty.DGraphType = "Duty"
	duty.Changed = time.Now().Unix()

	err := s.deletePredicateDB(duty.GUID, "rotationList")
	if err == nil {
		_, err := s.mutateDB(duty)
		if err != nil {
			lg.PrintErr(err)
		}
	}
	return duty.GUID, 1, err
}

// SetDutyAsDone sets a Duty as done and recalculates the timestamps
func (s *DGraph) SetDutyAsDone(guid string) (Duty, int, error) {
	duty, _, err := s.FetchSingleDutyByID(guid)
	if err != nil {
		lg.PrintErr(err)
	}
	duty.LastDone = time.Now().Unix()
	duty.NextDone = duty.NextDone + duty.RotationTime
	if int(duty.RotationIndex) != len(duty.RotationList)-1 {
		duty.RotationIndex++
	} else {
		duty.RotationIndex = 0
	}

	duty.DGraphType = "Duty"
	_, err = s.mutateDB(duty)
	if err != nil {
		lg.PrintErr(err)
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
							}
          				}
        			}
				}`

	err := s.queryDBWithVars(query, &comWrap, vars)
	if err != nil {
		return nil, 0, errors.WithStack(err)
	}

	return comWrap.Root[0].Duties, len(comWrap.Root[0].Duties), nil
}
