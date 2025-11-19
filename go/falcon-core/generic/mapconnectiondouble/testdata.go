package mapconnectiondouble

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	firstConnection  = mustBarrierGate("B1")
	secondConnection = mustBarrierGate("B2")
)
