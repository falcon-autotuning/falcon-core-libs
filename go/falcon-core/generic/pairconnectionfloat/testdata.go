package pairconnectionfloat

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
)

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultConnection = mustBarrierGate("B1")
	otherConnection   = mustBarrierGate("B2")
)
