package listacquisitioncontext

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustAcquisitionContext(port *instrumentport.Handle) *acquisitioncontext.Handle {
	h, err := acquisitioncontext.NewFromPort(port)
	if err != nil {
		panic(err)
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

var (
	defaultListData = []*acquisitioncontext.Handle{
		mustAcquisitionContext(mustInstrumentPort("B1", mustBarrierGate("B1"), instrumenttypes.VoltageSource(), mustVolt(), "")),
		mustAcquisitionContext(mustInstrumentPort("B2", mustBarrierGate("B2"), instrumenttypes.VoltageSource(), mustVolt(), "")),
	}
	otherListData = []*acquisitioncontext.Handle{
		mustAcquisitionContext(mustInstrumentPort("B3", mustBarrierGate("B3"), instrumenttypes.VoltageSource(), mustVolt(), "")),
	}
)
