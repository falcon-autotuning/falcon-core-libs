package listconnections

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
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
	defaultListData = []*connections.Handle{
		mustConnections("C1"),
		mustConnections("C2"),
	}
	otherListData = []*connections.Handle{
		mustConnections("P2"),
	}
)
