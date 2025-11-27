package listpairinstrumentportporttransform

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairinstrumentportporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
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

func mustPortTransform(port *instrumentport.Handle, val float64) *porttransform.Handle {
	h, err := porttransform.NewConstantTransform(port, val)
	if err != nil {
		panic(err)
	}
	return h
}

func mustPairInstrumentPortPortTransform(port *instrumentport.Handle, pt *porttransform.Handle) *pairinstrumentportporttransform.Handle {
	h, err := pairinstrumentportporttransform.New(port, pt)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairinstrumentportporttransform.Handle{
		mustPairInstrumentPortPortTransform(mustInstrumentPort("B1", mustBarrierGate("B1"), instrumenttypes.VoltageSource(), mustVolt(), ""), mustPortTransform(mustInstrumentPort("P1", mustBarrierGate("B1"), instrumenttypes.VoltageSource(), mustVolt(), ""), 1.0)),
		mustPairInstrumentPortPortTransform(mustInstrumentPort("B3", mustBarrierGate("B3"), instrumenttypes.VoltageSource(), mustVolt(), ""), mustPortTransform(mustInstrumentPort("P3", mustBarrierGate("B3"), instrumenttypes.VoltageSource(), mustVolt(), ""), 1.0)),
	}
	otherListData = []*pairinstrumentportporttransform.Handle{
		mustPairInstrumentPortPortTransform(mustInstrumentPort("B4", mustBarrierGate("B4"), instrumenttypes.VoltageSource(), mustVolt(), ""), mustPortTransform(mustInstrumentPort("P3", mustBarrierGate("B4"), instrumenttypes.VoltageSource(), mustVolt(), ""), 1.0)),
	}
)
