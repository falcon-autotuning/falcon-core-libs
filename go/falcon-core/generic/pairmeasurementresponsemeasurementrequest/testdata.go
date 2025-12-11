package pairmeasurementresponsemeasurementrequest

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/messages/measurementrequest"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/messages/measurementresponse"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listwaveform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinstrumentportporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/waveform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/analyticfunction"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledarrayslabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretespace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/unitspace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustLabelledMeasuredArray(name string) *labelledmeasuredarray.Handle {
	// Create a simple farraydouble
	fa, err := farraydouble.FromData([]float64{1.0, 2.0, 3.0}, []uint64{3})
	if err != nil {
		panic("failed to create farraydouble: " + err.Error())
	}
	defer fa.Close()
	conn, _ := connection.NewPlungerGate(name)
	v, _ := symbolunit.NewVolt()
	is, _ := instrumentport.NewKnob(name, conn, instrumenttypes.DCVoltageSource(), v, "")
	ac, err := acquisitioncontext.NewFromPort(is)
	if err != nil {
		panic("failed to create acquisitioncontext: " + err.Error())
	}
	defer ac.Close()
	// Create the labelled measured array from farray and acquisition context
	h, err := labelledmeasuredarray.FromFArray(fa, ac)
	if err != nil {
		panic("failed to create labelledmeasuredarray: " + err.Error())
	}
	return h
}

func mustLabelledArraysLabelledMeasuredArray(name string) *labelledarrayslabelledmeasuredarray.Handle {
	lm := mustLabelledMeasuredArray(name)
	defer lm.Close()
	list, err := listlabelledmeasuredarray.New([]*labelledmeasuredarray.Handle{lm})
	if err != nil {
		panic("failed to create listlabelledmeasuredarray: " + err.Error())
	}
	defer list.Close()
	h, err := labelledarrayslabelledmeasuredarray.NewFromList(list)
	if err != nil {
		panic("failed to create labelledarrayslabelledmeasuredarray: " + err.Error())
	}
	return h
}

func mustMeasurementResponse(name string) *measurementresponse.Handle {
	h, err := measurementresponse.New(mustLabelledArraysLabelledMeasuredArray(name))
	if err != nil {
		panic("failed to create measurement response")
	}
	return h
}

func mustMeasurementRequest(msg, name string) *measurementrequest.Handle {
	// --- Setup a minimal but real MeasurementRequest ---
	// Waveform
	wf := mustWaveform("A")
	defer wf.Close()
	wflist, err := listwaveform.New([]*waveform.Handle{wf})
	if err != nil {
		panic("failed to create listwaveform: " + err.Error())
	}
	defer wflist.Close()
	// Getter
	getter, err := ports.NewEmpty()
	if err != nil {
		panic("failed to create ports: " + err.Error())
	}
	defer getter.Close()
	// Meter transform
	pt := mustPortTransform(mustInstrumentPort("A"), 0.2)
	defer pt.Close()
	port := mustInstrumentPort("A")
	defer port.Close()
	meterTransforms, err := mapinstrumentportporttransform.New(nil)
	if err != nil {
		panic("failed to create mapinstrumentportporttransform: " + err.Error())
	}
	defer meterTransforms.Close()
	_ = meterTransforms.Insert(port, pt)
	// Time domain
	clock, _ := instrumentport.NewExecutionClock()
	timeDomain := mustLabelledDomain(0, 1.0, instrumenttypes.Clock(), clock, true, true)
	defer timeDomain.Close()
	// Construct
	h, err := measurementrequest.New(msg, name, wflist, getter, meterTransforms, timeDomain)
	if err != nil {
		panic("failed to create MeasurementRequest: " + err.Error())
	}
	return h
}

func mustWaveform(name string) *waveform.Handle {
	// Domain
	dom, err := domain.New(0, 1, true, true)
	if err != nil {
		panic(fmt.Errorf("domain.New error: %v", err))
	}
	// InstrumentPort
	v, _ := symbolunit.NewVolt()
	c, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(fmt.Errorf("connection.NewBarrierGate error: %v", err))
	}
	p, err := instrumentport.NewKnob(name, c, instrumenttypes.Voltmeter(), v, "")
	if err != nil {
		panic(fmt.Errorf("instrumentport.NewKnob error: %v", err))
	}
	// LabelledDomain
	ld, err := labelleddomain.NewFromPortAndDomain(p, dom)
	if err != nil {
		panic(fmt.Errorf("labelleddomain.NewFromPortAndDomain error: %v", err))
	}
	// CoupledLabelledDomain
	cld, err := coupledlabelleddomain.New([]*labelleddomain.Handle{ld})
	if err != nil {
		panic(fmt.Errorf("coupledlabelleddomain.New error: %v", err))
	}
	// AxesCoupledLabelledDomain
	axes, err := axescoupledlabelleddomain.NewEmpty()
	if err != nil {
		panic(fmt.Errorf("axescoupledlabelleddomain.NewEmpty error: %v", err))
	}
	axes.PushBack(cld)
	// MapStringBool
	pair, _ := pairstringbool.New(name, true)
	msb, err := mapstringbool.New([]*pairstringbool.Handle{pair})
	if err != nil {
		panic(fmt.Errorf("mapstringbool.New error: %v", err))
	}
	// AxesMapStringBool
	amap, err := axesmapstringbool.NewEmpty()
	if err != nil {
		panic(fmt.Errorf("axesmapstringbool.NewEmpty error: %v", err))
	}
	amap.PushBack(msb)
	// Discretizer
	discr, err := discretizer.NewCartesianDiscretizer(0.1)
	if err != nil {
		panic(fmt.Errorf("discretizer.NewCartesian error: %v", err))
	}
	ad, err := axesdiscretizer.New([]*discretizer.Handle{discr})
	if err != nil {
		panic(fmt.Errorf("axesdiscretizer.New error: %v", err))
	}
	// UnitSpace
	unit, err := unitspace.New(ad, dom)
	if err != nil {
		panic(fmt.Errorf("unitspace.New error: %v", err))
	}
	// DiscreteSpace
	ds, err := discretespace.New(unit, axes, amap)
	if err != nil {
		panic(fmt.Errorf("discretespace.New error: %v", err))
	}
	// AnalyticFunction
	labels, err := liststring.New([]string{"x"})
	if err != nil {
		panic(fmt.Errorf("liststring.New error: %v", err))
	}
	af, err := analyticfunction.New(labels, "2x[0]+1")
	if err != nil {
		panic(fmt.Errorf("analyticfunction.New error: %v", err))
	}
	// PortTransform
	pt, err := porttransform.New(p, af)
	if err != nil {
		panic(fmt.Errorf("porttransform.New error: %v", err))
	}
	// ListPortTransform
	lpt, err := listporttransform.New([]*porttransform.Handle{pt})
	if err != nil {
		panic(fmt.Errorf("listporttransform.New error: %v", err))
	}
	// Waveform
	w, err := waveform.New(ds, lpt)
	if err != nil {
		panic(fmt.Errorf("waveform.New error: %v", err))
	}
	return w
}

func mustPortTransform(port *instrumentport.Handle, val float64) *porttransform.Handle {
	h, err := porttransform.NewConstantTransform(port, val)
	if err != nil {
		panic(err)
	}
	return h
}

func mustInstrumentPort(name string) *instrumentport.Handle {
	v, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	conn, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(err)
	}
	h, err := instrumentport.NewKnob(name, conn, instrumenttypes.VoltageSource(), v, "A test port")
	if err != nil {
		panic(err)
	}
	return h
}

func mustLabelledDomain(minVal, maxVal float64, instrumentType string, port *instrumentport.Handle, lesserBoundContained, greaterBoundContained bool) *labelleddomain.Handle {
	h, err := labelleddomain.NewFromPort(minVal, maxVal, port, lesserBoundContained, greaterBoundContained)
	if err != nil {
		panic(fmt.Errorf("failed to craete a lablled domain: %v", err))
	}
	return h
}

var (
	defaultrequest  = mustMeasurementRequest("woah", "string")
	otherrequest    = mustMeasurementRequest("weee", "string")
	defaultresponse = mustMeasurementResponse("hello")
	otherresponse   = mustMeasurementResponse("world")
)
