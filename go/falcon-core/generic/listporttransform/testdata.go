package listporttransform

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
	defaultListData = []*porttransform.Handle{
		mustPortTransform(
			mustInstrumentPort("P2", mustBarrierGate("B2"), instrumenttypes.VoltageSource(), mustVolt(), ""), 1.0),
		mustPortTransform(
			mustInstrumentPort("P1", mustBarrierGate("P1"), instrumenttypes.VoltageSource(), mustVolt(), ""), 1.0),
	}
	otherListData = []*porttransform.Handle{
		mustPortTransform(mustInstrumentPort("P4", mustBarrierGate("B2"), instrumenttypes.VoltageSource(), mustVolt(), ""), 1.2),
	}
)
