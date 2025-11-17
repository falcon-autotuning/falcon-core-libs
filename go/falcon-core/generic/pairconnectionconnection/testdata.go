package pairconnectionconnection

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
	defaultConnection  = mustBarrierGate("B1")
	defaultConnection2 = mustBarrierGate("B4")
	otherConnection    = mustBarrierGate("B2")
	otherConnection2   = mustBarrierGate("B3")
)
