package listdotgatewithneighbors

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/dotgatewithneighbors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

func mustDotGateWithNeighbors(name string, left *connection.Handle, right *connection.Handle) *dotgatewithneighbors.Handle {
	h, err := dotgatewithneighbors.NewBarrierGateWithNeighbors(name, left, right)
	if err != nil {
		panic(err)
	}
	return h
}

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(fmt.Errorf("failed to create BarrierGate: %v", err))
	}
	return h
}

func mustPlungerGate(name string) *connection.Handle {
	h, err := connection.NewPlungerGate(name)
	if err != nil {
		panic(fmt.Errorf("failed to create PlungerGate: %v", err))
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*dotgatewithneighbors.Handle{
		mustDotGateWithNeighbors("B1", mustPlungerGate("hello"), mustPlungerGate("world")),
		mustDotGateWithNeighbors("B2", mustPlungerGate("woah"), mustPlungerGate("maybe")),
	}
	otherListData = []*dotgatewithneighbors.Handle{
		mustDotGateWithNeighbors("B3", mustPlungerGate("P1"), mustPlungerGate("P2")),
	}
)
