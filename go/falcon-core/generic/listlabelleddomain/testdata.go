package listlabelleddomain

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustLabelledDomain(minVal, maxVal float64, instrumentType string, port *instrumentport.Handle, lesserBoundContained, greaterBoundContained bool) *labelleddomain.Handle {
	h, err := labelleddomain.NewFromPort(minVal, maxVal, instrumentType, port, lesserBoundContained, greaterBoundContained)
	if err != nil {
		panic(fmt.Errorf("failed to craete a lablled domain: %v", err))
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
	defaultListData = []*labelleddomain.Handle{
		mustLabelledDomain(0.0, 1.0, instrumenttypes.VoltageSource(), mustInstrumentPort("B1", mustBarrierGate("B1"), instrumenttypes.VoltageSource(), mustVolt(), ""), true, true),
		mustLabelledDomain(0.0, 1.0, instrumenttypes.VoltageSource(), mustInstrumentPort("B3", mustBarrierGate("B3"), instrumenttypes.VoltageSource(), mustVolt(), ""), true, true),
	}
	otherListData = []*labelleddomain.Handle{
		mustLabelledDomain(0.0, 1.0, instrumenttypes.VoltageSource(), mustInstrumentPort("P2", mustBarrierGate("P2"), instrumenttypes.VoltageSource(), mustVolt(), ""), true, true),
	}
)
