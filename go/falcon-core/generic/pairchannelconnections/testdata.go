package pairchannelconnections

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
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

func mustChannel(name string) *channel.Handle {
	h, err := channel.New(name)
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
	defaultChannel     = mustChannel("C1")
	defaultConnections = mustConnections("B4")
	otherChannel       = mustChannel("C2")
	otherConnections   = mustConnections("B3")
)
