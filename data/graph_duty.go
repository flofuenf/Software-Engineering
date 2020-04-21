package data

import (
	"time"
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
