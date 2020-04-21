package data

import "time"

// AddDuty adds a Duty to Database
func (s *DGraph) AddDuty(duty *Duty) error {
	duty.DGraphType = "Duty"
	duty.GUID = "_:" + duty.DGraphType
	duty.Created = time.Now().Unix()
	uids, err := s.mutateDB(duty)
	duty.GUID = uids[duty.DGraphType]
	return err
}
