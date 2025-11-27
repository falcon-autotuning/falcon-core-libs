package axeslabelledmeasuredarray1d

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray1d"
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

func mustmeasuredArray(data []float64, shape []int) *labelledmeasuredarray1d.Handle {
	f, err := farraydouble.FromData(data, shape)
	if err != nil {
		panic(err)
	}
	ac := mustAcquisitionContext(mustInstrumentPort("B1", mustBarrierGate("B1"), instrumenttypes.VoltageSource(), mustVolt(), ""))
	h, err := labelledmeasuredarray1d.FromFArray(f, ac)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultAxesData = []*labelledmeasuredarray1d.Handle{
		mustmeasuredArray([]float64{0.0, 1.0}, []int{2}),
		mustmeasuredArray([]float64{0.0, 1.0, 2.0, 3.0}, []int{4}),
	}
	otherAxesData = []*labelledmeasuredarray1d.Handle{
		mustmeasuredArray([]float64{0.5, 1.0, 2.0, 3.0}, []int{4}),
	}
)
