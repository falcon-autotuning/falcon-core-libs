package listconnection

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
)

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
	defaultListData = []*connection.Handle{
		mustPlungerGate("P1"),
		mustBarrierGate("B1"),
	}
	otherListData = []*connection.Handle{
		mustPlungerGate("P2"),
	}
)
