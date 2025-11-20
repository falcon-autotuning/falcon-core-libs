package listwaveform

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/waveform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/analyticfunction"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretespace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/unitspace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

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
	discr, err := discretizer.NewCartesian(0.1)
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

var (
	defaultListData = []*waveform.Handle{
		mustWaveform("W1"),
		mustWaveform("W2"),
	}
	otherListData = []*waveform.Handle{
		mustWaveform("W4"),
	}
)
