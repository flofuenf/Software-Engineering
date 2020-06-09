package data

import (
	"time"

	"git.rrdc.de/lib/lg"

	"git.rrdc.de/lib/errors"
)

// InsertConsumable adds a Duty to Database
func (s *DGraph) InsertConsumable(con *Consumable) error {
	con.DGraphType = "Consumable"
	con.GUID = "_:" + con.DGraphType
	con.Created = time.Now().Unix()
	con.Changed = time.Now().Unix()
	con.RotationIndex = 0
	con.IsNeeded = false
	uids, err := s.mutateDB(con)
	con.GUID = uids[con.DGraphType]
	return err
}

// FetchConsumablesByID queries a commune by it's ID
func (s *DGraph) FetchConsumablesByID(guid string) (interface{}, int, error) {
	var (
		comWrap CommuneWrapper
		vars    = make(map[string]string)
	)

	vars["$guid"] = guid
	query := `query query($guid: string){
					query(func: uid($guid))@filter(type(Commune)){
          				consumables{
            				uid
            				created
            				changed
            				name
							isNeeded
							lastBought
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

	if len(comWrap.Root) < 1 {
		return nil, 0, nil
	}

	return comWrap.Root[0].Consumables, len(comWrap.Root[0].Consumables), nil
}

// SwitchConsumableAsBought sets a Duty as done and recalculates the timestamps
func (s *DGraph) SwitchConsumableAsBought(guid string) (Consumable, int, error) {
	con, _, err := s.FetchSingleConsumableByID(guid)
	if err != nil {
		lg.PrintErr(err)
	}

	if con.IsNeeded {
		con.LastBought = time.Now().Unix()
		if int(con.RotationIndex) != len(con.RotationList)-1 {
			con.RotationIndex++
		} else {
			con.RotationIndex = 0
		}
	}

	con.IsNeeded = !con.IsNeeded

	con.DGraphType = "Consumable"
	_, err = s.mutateDB(con)
	if err != nil {
		lg.PrintErr(err)
	}

	return con, 1, nil
}

// FetchSingleConsumableByID fetches a single Duty by ID
func (s *DGraph) FetchSingleConsumableByID(guid string) (Consumable, int, error) {
	var (
		conWrap ConsumableWrapper
		vars    = make(map[string]string)
	)

	vars["$guid"] = guid
	query := `query query($guid: string){
					query(func: uid($guid))@filter(type(Consumable)){
            				uid
            				created
            				changed
            				name
							isNeeded
							lastBought
							rotationIndex
							rotationList{
								uid
								name
							}
        			}
				}`

	err := s.queryDBWithVars(query, &conWrap, vars)
	if err != nil {
		return Consumable{}, 0, errors.WithStack(err)
	}

	return conWrap.Root[0], len(conWrap.Root), nil
}
