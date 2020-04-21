package data

import "time"

// AddAddress adds a Address to Database
func (s *DGraph) AddAddress(address *Address) error {
	address.DGraphType = "Address"
	address.GUID = "_:" + address.DGraphType
	address.Created = time.Now().Unix()
	uids, err := s.mutateDB(address)
	address.GUID = uids[address.DGraphType]
	return err
}
