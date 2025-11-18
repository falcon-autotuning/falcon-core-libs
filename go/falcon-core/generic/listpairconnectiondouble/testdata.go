package listpairconnectiondouble

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

func mustPairConnectionDouble(conn *connection.Handle, val float64) *pairconnectiondouble.Handle {
	h, err := pairconnectiondouble.New(conn, val)
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
	defaultListData = []*pairconnectiondouble.Handle{
		mustPairConnectionDouble(mustBarrierGate("Chan1"), 1.0),
		mustPairConnectionDouble(mustBarrierGate("Chan2"), 1.4),
	}
	otherListData = []*pairconnectiondouble.Handle{
		mustPairConnectionDouble(mustBarrierGate("Chan3"), 1.3),
	}
)
