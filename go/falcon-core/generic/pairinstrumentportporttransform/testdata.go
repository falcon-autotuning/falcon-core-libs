package pairinstrumentportporttransform

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
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

func mustPortTransform(port *instrumentport.Handle, val float64) *porttransform.Handle {
	h, err := porttransform.NewConstantTransform(port, val)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultInstrumentPort = mustInstrumentPort("B1", mustBarrierGate("B1"), instrumenttypes.VoltageSource(), mustVolt(), "")
	defaultPortTransform  = mustPortTransform(
		mustInstrumentPort("P2", mustBarrierGate("B2"), instrumenttypes.VoltageSource(), mustVolt(), ""), 1.0)
	otherInstrumentPort = mustInstrumentPort("B3", mustBarrierGate("B3"), instrumenttypes.VoltageSource(), mustVolt(), "")
	otherPortTransform  = mustPortTransform(
		mustInstrumentPort("P4", mustBarrierGate("B2"), instrumenttypes.VoltageSource(), mustVolt(), ""), 1.2)
)
