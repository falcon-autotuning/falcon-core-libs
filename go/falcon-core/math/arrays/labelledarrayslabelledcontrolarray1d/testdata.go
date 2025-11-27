package labelledarrayslabelledcontrolarray1d

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledcontrolarray1d"
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

func mustControlArray(data []float64, shape []int, name string) *labelledcontrolarray1d.Handle {
	f, err := farraydouble.FromData(data, shape)
	if err != nil {
		panic(err)
	}
	ac := mustAcquisitionContext(mustInstrumentPort(name, mustBarrierGate(name), instrumenttypes.VoltageSource(), mustVolt(), ""))
	h, err := labelledcontrolarray1d.FromFArray(f, ac)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultListData = []*labelledcontrolarray1d.Handle{
		mustControlArray([]float64{0.0, 1.0}, []int{2}, "B1"),
		mustControlArray([]float64{0.0, 1.0, 2.0, 3.0}, []int{4}, "B2"),
	}
	otherListData = []*labelledcontrolarray1d.Handle{
		mustControlArray([]float64{0.5, 1.0, 2.0, 3.0}, []int{4}, "B3"),
	}
)
