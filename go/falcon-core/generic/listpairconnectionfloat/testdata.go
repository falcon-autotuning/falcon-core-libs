package listpairconnectionfloat

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionfloat"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

func mustPairConnectionFloat(conn *connection.Handle, val float32) *pairconnectionfloat.Handle {
	h, err := pairconnectionfloat.New(conn, val)
	if err != nil {
		panic(err)
	}
	return h
}

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairconnectionfloat.Handle{
		mustPairConnectionFloat(mustBarrierGate("Chan1"), 1.0),
		mustPairConnectionFloat(mustBarrierGate("Chan2"), 1.4),
	}
	otherListData = []*pairconnectionfloat.Handle{
		mustPairConnectionFloat(mustBarrierGate("Chan3"), 1.3),
	}
)
