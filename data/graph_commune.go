package data

import (
	"time"

	"git.rrdc.de/lib/errors"
)

// AddCommune adds a Commune to Database
func (s *DGraph) AddCommune(commune *Commune) error {
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
