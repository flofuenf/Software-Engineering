package data

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/pkg/errors"

	dgo "github.com/dgraph-io/dgo/v2"
	"github.com/dgraph-io/dgo/v2/protos/api"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

// DGraph describes the structures of a DGraph client
type DGraph struct {
	conn   *grpc.ClientConn
	client *dgo.Dgraph
	ctx    context.Context
}

// SetupDgraph declares the DGraph Client for further use
func SetupDgraph(url string) (*DGraph, error) {
	conn, err := grpc.Dial(url, grpc.WithInsecure())
	if err != nil {
		return nil, errors.WithStack(err)
	}
	return &DGraph{
		conn:   conn,
		client: dgo.NewDgraphClient(api.NewDgraphClient(conn)),
		ctx:    context.Background(),
	}, nil
}

// ############# Commented out because it's not used (yet) #############
// func (s *DGraph) queryDB(query string, object interface{}) error {
// 	req := s.client.NewReadOnlyTxn()
// 	req.BestEffort()
// 	res, err := req.Query(s.ctx, query)
// 	if err != nil {
// 		return errors.WithStack(err)
// 	}
// 	err = json.Unmarshal(res.Json, object)
// 	return errors.WithStack(err)
// }

func (s *DGraph) mutateDB(object interface{}) (map[string]string, error) {
	req := s.client.NewTxn()
	obj, err := json.Marshal(object)

	if err != nil {
		return nil, errors.WithStack(err)
	}
	mu := &api.Mutation{
		SetJson:   obj,
		CommitNow: true,
	}

	res, err := req.Mutate(s.ctx, mu)
	if err != nil {
		return nil, errors.WithStack(err)
	}

	return res.Uids, errors.WithStack(err)
}

func (s *DGraph) queryDBWithVars(query string, object interface{}, vars map[string]string) error {
	req := s.client.NewTxn()
	res, err := req.QueryWithVars(s.ctx, query, vars)
	if err != nil {
		return errors.WithStack(err)
	}
	err = json.Unmarshal(res.Json, object)
	return errors.WithStack(err)
}

func (s *DGraph) mutateSinglePred(uid, pred, obj string) error {
	req := s.client.NewTxn()

	mu := &api.Mutation{
		SetJson:   []byte(fmt.Sprintf(`[{"uid": "%s", "%s": {"uid": "%s"}}]`, uid, pred, obj)),
		CommitNow: true,
	}

	_, err := req.Mutate(s.ctx, mu)
	if err != nil {
		return errors.WithStack(err)
	}
	return errors.WithStack(err)
}

func (s *DGraph) deleteObjectDB(uid, pred, obj string) error {
	req := s.client.NewTxn()

	mu := &api.Mutation{
		DeleteJson: []byte(fmt.Sprintf(`[{"uid": "%s", "%s": {"uid": "%s"}}]`, uid, pred, obj)),
		CommitNow:  true,
	}

	_, err := req.Mutate(s.ctx, mu)
	if err != nil {
		return errors.WithStack(err)
	}
	return errors.WithStack(err)
}

func (s *DGraph) deletePredicateDB(uid, pred string) error {
	req := s.client.NewTxn()

	mu := &api.Mutation{
		Del: []*api.NQuad{
			{
				Subject:   uid,
				Predicate: pred,
				ObjectValue: &api.Value{
					Val: &api.Value_DefaultVal{DefaultVal: "_STAR_ALL"}},
			},
		},
		CommitNow: true,
	}

	_, err := req.Mutate(s.ctx, mu)
	if err != nil {
		return errors.WithStack(err)
	}
	return errors.WithStack(err)
}

func (s *DGraph) deleteEdgeDB(uid string) error {
	req := s.client.NewTxn()

	mu := &api.Mutation{
		DeleteJson: []byte(fmt.Sprintf(`{"uid": "%s"}`, uid)),
		CommitNow:  true,
	}

	_, err := req.Mutate(s.ctx, mu)
	if err != nil {
		return errors.WithStack(err)
	}
	return errors.WithStack(err)
}

// Close closes the established connection
func (s *DGraph) Close() {
	log.Println(s.conn.Close())
}

// ###########################These functions may be needed (no complete package till now)###########################
// func (s *DGraph) mutateSinglePredInt(uid, pred string, obj int) error {
// 	req := s.client.NewTxn()
//
// 	mu := &api.Mutation{
// 		SetJson:   []byte(fmt.Sprintf(`[{"uid": "%s", "%s": %v}]`, uid, pred, obj)),
// 		CommitNow: true,
// 	}
//
// 	_, err := req.Mutate(s.ctx, mu)
// 	if err != nil {
// 		return errors.WithStack(err)
// 	}
// 	return errors.WithStack(err)
// }

// func (s *DGraph) mutateSinglePredFloat(uid, pred string, obj float32) error {
// 	req := s.client.NewTxn()
//
// 	mu := &api.Mutation{
// 		SetJson:   []byte(fmt.Sprintf(`[{"uid": "%s", "%s": %f}]`, uid, pred, obj)),
// 		CommitNow: true,
// 	}
//
// 	_, err := req.Mutate(s.ctx, mu)
// 	if err != nil {
// 		return errors.WithStack(err)
// 	}
// 	return errors.WithStack(err)
// }
//
// func (s *DGraph) mutateSinglePredBool(uid, pred string, obj bool) error {
// 	req := s.client.NewTxn()
//
// 	mu := &api.Mutation{
// 		SetJson:   []byte(fmt.Sprintf(`[{"uid": "%s", "%s": %v}]`, uid, pred, obj)),
// 		CommitNow: true,
// 	}
//
// 	_, err := req.Mutate(s.ctx, mu)
// 	if err != nil {
// 		return errors.WithStack(err)
// 	}
// 	return errors.WithStack(err)
// }
