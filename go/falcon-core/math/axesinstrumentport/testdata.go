package axesinstrumentport

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(fmt.Errorf("failed to create BarrierGate: %v", err))
	}
	return h
}

func mustInstrumentPort(name string, conn *connection.Handle, insttype string, unit *symbolunit.Handle, desc string) *instrumentport.Handle {
	h, err := instrumentport.NewKnob(name, conn, insttype, unit, desc)
	if err != nil {
		panic(fmt.Errorf("failed to create Knob: %v", err))
	}
	return h
}

func mustVolt() *symbolunit.Handle {
	h, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultAxesData = []*instrumentport.Handle{
		mustInstrumentPort("B1", mustBarrierGate("B1"), instrumenttypes.VoltageSource(), mustVolt(), ""),
		mustInstrumentPort("B3", mustBarrierGate("B3"), instrumenttypes.VoltageSource(), mustVolt(), ""),
	}
	otherAxesData = []*instrumentport.Handle{
		mustInstrumentPort("P2", mustBarrierGate("P2"), instrumenttypes.VoltageSource(), mustVolt(), ""),
	}
)
