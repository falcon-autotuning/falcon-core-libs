package listpairconnectionconnections

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

func mustPairConnectionConnections(conn *connection.Handle, conns *connections.Handle) *pairconnectionconnections.Handle {
	h, err := pairconnectionconnections.New(conn, conns)
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

func mustGates(names ...string) []*connection.Handle {
	var handles []*connection.Handle
	for _, n := range names {
		handles = append(handles, mustBarrierGate(n))
	}
	return handles
}

func mustConnections(names ...string) *connections.Handle {
	handles := mustGates(names...)
	h, err := connections.New(handles)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairconnectionconnections.Handle{
		mustPairConnectionConnections(mustBarrierGate("Chan1"), mustConnections("P1", "P2")),
		mustPairConnectionConnections(mustBarrierGate("Chan2"), mustConnections("P3", "P4")),
	}
	otherListData = []*pairconnectionconnections.Handle{
		mustPairConnectionConnections(mustBarrierGate("Chan3"), mustConnections("P6", "P5")),
	}
)
