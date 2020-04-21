package data

// Commune describes a Commune Object
type Commune struct {
	GUID        string  `json:"uid"`
	DGraphType  string  `json:"dgraph.type"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Created     int64   `json:"created"`
	Moderators  []User  `json:"moderators"`
	Address     Address `json:"address"`
}

// User describes an User Object
type User struct {
	GUID       string  `json:"uid"`
	DGraphType string  `json:"dgraph.type"`
	Name       string  `json:"name"`
	Created    int64   `json:"created"`
	Birth      int64   `json:"birth"`
	MemberOf   Commune `json:"member_of"`
}

// Address describes an Address Object
type Address struct {
	GUID       string `json:"uid"`
	DGraphType string `json:"dgraph.type"`
	Created    int64  `json:"created"`
	Street     string `json:"street"`
	City       string `json:"city"`
	Zip        string `json:"zip"`
}

// Duty describes an Duty Object
type Duty struct {
	GUID        string `json:"uid"`
	DGraphType  string `json:"dgraph.type"`
	Created     int64  `json:"created"`
	Changed     int64  `json:"created"`
	Name        string `json:"name"`
	Description string `json:"description"`
	LastDone    int64  `json:"lastdone"`
}
