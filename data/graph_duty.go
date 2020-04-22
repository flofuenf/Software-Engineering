package data

import (
	"time"

	"git.rrdc.de/lib/errors"
)

// InsertDuty adds a Duty to Database
func (s *DGraph) InsertDuty(duty *Duty) error {
	duty.DGraphType = "Duty"
	duty.GUID = "_:" + duty.DGraphType
	duty.Created = time.Now().Unix()
	duty.Changed = time.Now().Unix()
	duty.LastDone = 0
	duty.NextDone = time.Now().Unix() + duty.RotationTime
	uids, err := s.mutateDB(duty)
	duty.GUID = uids[duty.DGraphType]
	return err
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
