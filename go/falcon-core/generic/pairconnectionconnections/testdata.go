package pairconnectionconnections

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connections"
)

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

var (
	defaultConnection  = mustBarrierGate("B1")
	defaultConnections = mustConnections("B4")
	otherConnection    = mustBarrierGate("B2")
	otherConnections   = mustConnections("B3")
)
