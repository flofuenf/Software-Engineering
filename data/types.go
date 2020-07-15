package data

// Commune describes a Commune Object
type Commune struct {
	GUID        string       `json:"uid,omitempty"`
	DGraphType  string       `json:"dgraph.type,omitempty"`
	Name        string       `json:"name,omitempty"`
	Description string       `json:"description,omitempty"`
	Created     int64        `json:"created,omitempty"`
	Members     []User       `json:"members,omitempty"`
	Address     Address      `json:"address,omitempty"`
	Duties      []Duty       `json:"duties,omitempty"`
	Consumables []Consumable `json:"consumables,omitempty"`
}

// CommuneWrapper describes a Commune Object
type CommuneWrapper struct {
	Root []Commune `json:"query"`
}

// DutyWrapper describes a Commune Object
type DutyWrapper struct {
	Root []Duty `json:"query"`
}

// ConsumableWrapper describes a Commune Object
type ConsumableWrapper struct {
	Root []Consumable `json:"query"`
}

// User describes an User Object
type User struct {
	GUID       string `json:"uid,omitempty"`
	DGraphType string `json:"dgraph.type,omitempty"`
	Name       string `json:"name,omitempty"`
	Created    int64  `json:"created,omitempty"`
	Birth      int64  `json:"birth,omitempty"`
}

type Auth struct {
	GUID         string `json:"uid"`
	Mail         string `json:"mail"`
	Pass         string `json:"pass"`
	UserID       string `json:"userID"`
	Name         string `json:"name"`
	Birth        int64  `json:"birth"`
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

// UserWrapper describes a Commune Object
type UserWrapper struct {
	Root []User `json:"query"`
}

// Address describes an Address Object
type Address struct {
	GUID       string `json:"uid,omitempty"`
	DGraphType string `json:"dgraph.type,omitempty"`
	Created    int64  `json:"created,omitempty"`
	Street     string `json:"street,omitempty"`
	City       string `json:"city,omitempty"`
	Zip        string `json:"zip,omitempty"`
}

// Duty describes an Duty Object
type Duty struct {
	GUID          string `json:"uid,omitempty"`
	DGraphType    string `json:"dgraph.type,omitempty"`
	Created       int64  `json:"created,omitempty"`
	Changed       int64  `json:"changed,omitempty"`
	Name          string `json:"name,omitempty"`
	Description   string `json:"description,omitempty"`
	LastDone      int64  `json:"lastDone,omitempty"`
	NextDone      int64  `json:"nextDone,omitempty"`
	RotationTime  int64  `json:"rotationTime,omitempty"`
	RotationIndex int64  `json:"rotationIndex"`
	RotationList  []User `json:"rotationList,omitempty"`
}

// Consumable describes an Consumable Object
type Consumable struct {
	GUID          string `json:"uid,omitempty"`
	DGraphType    string `json:"dgraph.type,omitempty"`
	Created       int64  `json:"created,omitempty"`
	Changed       int64  `json:"changed,omitempty"`
	Name          string `json:"name,omitempty"`
	IsNeeded      bool   `json:"isNeeded"`
	LastBought    int64  `json:"lastBought"`
	RotationIndex int64  `json:"rotationIndex"`
	RotationList  []User `json:"rotationList,omitempty"`
}
