package waveform

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/analyticfunction"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
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

func makeTestDomain(t *testing.T) *domain.Handle {
	d, err := domain.New(0, 1, true, true)
	if err != nil {
		t.Fatalf("domain.New error: %v", err)
	}
	return d
}

func makeTestInstrumentPort(t *testing.T, name string) *instrumentport.Handle {
	v, _ := symbolunit.NewVolt()
	c, err := connection.NewBarrierGate(name)
	if err != nil {
		t.Fatalf("connection.NewBarrierGate error: %v", err)
	}
	p, err := instrumentport.NewKnob(name, c, instrumenttypes.Voltmeter(), v, "")
	if err != nil {
		t.Fatalf("instrumentport.NewKnob error: %v", err)
	}
	return p
}

func makeTestLabelledDomain(t *testing.T, port *instrumentport.Handle, dom *domain.Handle) *labelleddomain.Handle {
	ld, err := labelleddomain.NewFromPortAndDomain(port, dom)
	if err != nil {
		t.Fatalf("labelleddomain.NewFromPortAndDomain error: %v", err)
	}
	return ld
}

func makeTestCoupledLabelledDomain(t *testing.T, ld *labelleddomain.Handle) *coupledlabelleddomain.Handle {
	c, err := coupledlabelleddomain.New([]*labelleddomain.Handle{ld})
	if err != nil {
		t.Fatalf("coupledlabelleddomain.New error: %v", err)
	}
	return c
}

func makeTestAxesCoupledLabelledDomain(t *testing.T, cld *coupledlabelleddomain.Handle) *axescoupledlabelleddomain.Handle {
	a, err := axescoupledlabelleddomain.NewEmpty()
	if err != nil {
		t.Fatalf("axescoupledlabelleddomain.NewEmpty error: %v", err)
	}
	a.PushBack(cld)
	return a
}

func makeTestAxesInt(t *testing.T, vals ...int32) *axesint.Handle {
	a, err := axesint.New(vals)
	if err != nil {
		t.Fatalf("axesint.New error: %v", err)
	}
	return a
}

func makeTestMapStringBool(t *testing.T, name string) *mapstringbool.Handle {
	p, _ := pairstringbool.New(name, true)
	m, err := mapstringbool.New([]*pairstringbool.Handle{p})
	if err != nil {
		t.Fatalf("mapstringbool.New error: %v", err)
	}
	return m
}

func makeTestAxesMapStringBool(t *testing.T, m *mapstringbool.Handle) *axesmapstringbool.Handle {
	a, err := axesmapstringbool.NewEmpty()
	if err != nil {
		t.Fatalf("axesmapstringbool.NewEmpty error: %v", err)
	}
	a.PushBack(m)
	return a
}

func makeTestUnitSpace(t *testing.T, dom *domain.Handle) *unitspace.Handle {
	discr, err := discretizer.NewCartesianDiscretizer(0.1)
	if err != nil {
		t.Fatalf("unitspace.NewDiscretizerCartesian error: %v", err)
	}
	ad, err := axesdiscretizer.New([]*discretizer.Handle{discr})
	if err != nil {
		t.Fatalf("unitspace.NewAxesDiscretizer error: %v", err)
	}
	u, err := unitspace.New(ad, dom)
	if err != nil {
		t.Fatalf("unitspace.New error: %v", err)
	}
	return u
}

func makeTestAnalyticFunction(t *testing.T) *analyticfunction.Handle {
	labels, err := liststring.New([]string{"x"})
	if err != nil {
		t.Fatalf("str.NewList error: %v", err)
	}
	af, err := analyticfunction.New(labels, "2x[0]+1")
	if err != nil {
		t.Fatalf("analyticfunction.New error: %v", err)
	}
	return af
}

func makeTestPortTransform(t *testing.T, port *instrumentport.Handle, analytic *analyticfunction.Handle) *porttransform.Handle {
	pt, err := porttransform.New(port, analytic)
	if err != nil {
		t.Fatalf("porttransform.New error: %v", err)
	}
	return pt
}

func makeTestListPortTransform(t *testing.T, pt *porttransform.Handle) *listporttransform.Handle {
	l, err := listporttransform.New([]*porttransform.Handle{pt})
	if err != nil {
		t.Fatalf("listporttransform.New error: %v", err)
	}
	return l
}

func makeTestDiscreteSpace(t *testing.T, unit *unitspace.Handle, axes *axescoupledlabelleddomain.Handle, incr *axesmapstringbool.Handle) *discretespace.Handle {
	ds, err := discretespace.New(unit, axes, incr)
	if err != nil {
		t.Fatalf("discretespace.New error: %v", err)
	}
	return ds
}

func setupWaveformTest(t *testing.T) (dom *domain.Handle, port *instrumentport.Handle, port2 *instrumentport.Handle, ld *labelleddomain.Handle, ld2 *labelleddomain.Handle, cld *coupledlabelleddomain.Handle, cld2 *coupledlabelleddomain.Handle, axes *axescoupledlabelleddomain.Handle, mapSB *mapstringbool.Handle, mapSB2 *mapstringbool.Handle, incr *axesmapstringbool.Handle, unit *unitspace.Handle, ds *discretespace.Handle, analytic *analyticfunction.Handle, pt *porttransform.Handle, lpt *listporttransform.Handle, divisions *axesint.Handle) {
	dom = makeTestDomain(t)
	port = makeTestInstrumentPort(t, "A")
	port2 = makeTestInstrumentPort(t, "B")
	ld = makeTestLabelledDomain(t, port, dom)
	ld2 = makeTestLabelledDomain(t, port2, dom)
	cld = makeTestCoupledLabelledDomain(t, ld)
	cld2 = makeTestCoupledLabelledDomain(t, ld2)
	axes = makeTestAxesCoupledLabelledDomain(t, cld)
	mapSB = makeTestMapStringBool(t, "A")
	mapSB2 = makeTestMapStringBool(t, "B")
	incr = makeTestAxesMapStringBool(t, mapSB)
	unit = makeTestUnitSpace(t, dom)
	ds = makeTestDiscreteSpace(t, unit, axes, incr)
	analytic = makeTestAnalyticFunction(t)
	pt = makeTestPortTransform(t, port, analytic)
	lpt = makeTestListPortTransform(t, pt)
	divisions = makeTestAxesInt(t, 2)
	return dom, port, port2, ld, ld2, cld, cld2, axes, mapSB, mapSB2, incr, unit, ds, analytic, pt, lpt, divisions
}

func TestWaveform_Constructors(t *testing.T) {
	dom := makeTestDomain(t)
	portA := makeTestInstrumentPort(t, "A")
	portB := makeTestInstrumentPort(t, "B")
	ldA := makeTestLabelledDomain(t, portA, dom)
	ldB := makeTestLabelledDomain(t, portB, dom)
	cldA := makeTestCoupledLabelledDomain(t, ldA)
	cldB := makeTestCoupledLabelledDomain(t, ldB)
	axes := makeTestAxesCoupledLabelledDomain(t, cldA)
	mapSBA := makeTestMapStringBool(t, "A")
	mapSBB := makeTestMapStringBool(t, "B")
	incr := makeTestAxesMapStringBool(t, mapSBA)
	unit := makeTestUnitSpace(t, dom)
	ds := makeTestDiscreteSpace(t, unit, axes, incr)
	analytic := makeTestAnalyticFunction(t)
	pt := makeTestPortTransform(t, portA, analytic)
	lpt := makeTestListPortTransform(t, pt)
	divisions := makeTestAxesInt(t, 2)

	// 2D setup: use two distinct axes/domains/maps
	divisions2D := makeTestAxesInt(t, 2, 2)
	axes2D, err := axescoupledlabelleddomain.NewEmpty()
	if err != nil {
		t.Fatalf("axescoupledlabelleddomain.NewEmpty error: %v", err)
	}
	axes2D.PushBack(cldA)
	axes2D.PushBack(cldB)
	incr2D, err := axesmapstringbool.NewEmpty()
	if err != nil {
		t.Fatalf("axesmapstringbool.NewEmpty error: %v", err)
	}
	incr2D.PushBack(mapSBA)
	incr2D.PushBack(mapSBB)

	// 1D and regular constructors
	w, err := New(ds, lpt)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer w.Close()
	wc, err := NewCartesianWaveform(divisions, axes, incr, lpt, dom)
	if err != nil {
		t.Fatalf("NewCartesian error: %v", err)
	}
	defer wc.Close()
	wci, err := NewCartesianIdentityWaveform(divisions, axes, incr, dom)
	if err != nil {
		t.Fatalf("NewCartesianIdentity error: %v", err)
	}
	defer wci.Close()
	wc2d, err := NewCartesianWaveform2D(divisions2D, axes2D, incr2D, lpt, dom)
	if err != nil {
		t.Fatalf("NewCartesian2D error: %v", err)
	}
	defer wc2d.Close()
	wci2d, err := NewCartesianIdentityWaveform2D(divisions2D, axes2D, incr2D, dom)
	if err != nil {
		t.Fatalf("NewCartesianIdentity2D error: %v", err)
	}
	defer wci2d.Close()
	wc1d, err := NewCartesianWaveform1D(2, cldA, mapSBA, lpt, dom)
	if err != nil {
		t.Fatalf("NewCartesian1D error: %v", err)
	}
	defer wc1d.Close()
	wci1d, err := NewCartesianIdentityWaveform1D(2, cldA, mapSBA, dom)
	if err != nil {
		t.Fatalf("NewCartesianIdentity1D error: %v", err)
	}
	defer wci1d.Close()
}

func TestWaveform_Accessors(t *testing.T) {
	_, _, _, _, _, _, _, _, _, _, _, _, ds, _, _, lpt, _ := setupWaveformTest(t)
	w, err := New(ds, lpt)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer w.Close()

	space, err := w.Space()
	if err != nil {
		t.Errorf("Space error: %v", err)
	}
	space.Close()
	trans, err := w.Transforms()
	if err != nil {
		t.Errorf("Transforms error: %v", err)
	}
	trans.Close()
	size, err := w.Size()
	if err != nil || size != 1 {
		t.Errorf("Size error: %v %d", err, size)
	}
	empty, err := w.Empty()
	if err != nil || empty {
		t.Errorf("Empty error: %v %v", err, empty)
	}
	item, err := w.At(0)
	if err != nil {
		t.Errorf("At error: %v", err)
	}
	item.Close()
	items, err := w.Items()
	if err != nil {
		t.Errorf("Items error: %v", err)
	}
	otheritems, err := items.Items()
	if err != nil {
		t.Errorf("Second Items error: %v", err)
	}
	for _, it := range otheritems {
		it.Close()
	}
}

func TestWaveform_Mutators(t *testing.T) {
	_, port, _, _, _, _, _, _, _, _, _, _, ds, _, _, lpt, _ := setupWaveformTest(t)
	w, err := New(ds, lpt)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer w.Close()

	pt2, err := porttransform.NewConstantTransform(port, 5.0)
	if err != nil {
		t.Fatalf("porttransform.NewConstant error: %v", err)
	}
	defer pt2.Close()
	if err := w.PushBack(pt2); err != nil {
		t.Errorf("PushBack error: %v", err)
	}
	if err := w.EraseAt(0); err != nil {
		t.Errorf("EraseAt error: %v", err)
	}
	if err := w.Clear(); err != nil {
		t.Errorf("Clear error: %v", err)
	}
}

func TestWaveform_ContainsIndex(t *testing.T) {
	_, _, _, _, _, _, _, _, _, _, _, _, ds, _, pt, lpt, _ := setupWaveformTest(t)
	w, err := New(ds, lpt)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer w.Close()

	ok, err := w.Contains(pt)
	if err != nil {
		t.Errorf("Contains error: %v", err)
	}
	if !ok {
		t.Errorf("Expected Contains to be true for pt")
	}
	_, err = w.Index(pt)
	if err != nil {
		t.Errorf("Index error: %v", err)
	}
}

func TestWaveform_EqualityIntersection(t *testing.T) {
	_, _, _, _, _, _, _, _, _, _, _, _, ds, _, _, lpt, _ := setupWaveformTest(t)
	w1, err := New(ds, lpt)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer w1.Close()
	w2, err := New(ds, lpt)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer w2.Close()
	eq, err := w1.Equal(w2)
	if err != nil || !eq {
		t.Errorf("Equal error: %v %v", err, eq)
	}
	neq, err := w1.NotEqual(w2)
	if err != nil || neq {
		t.Errorf("NotEqual error: %v %v", err, neq)
	}
	inter, err := w1.Intersection(w2)
	if err != nil {
		t.Errorf("Intersection error: %v", err)
	}
	inter.Close()
}

func TestWaveform_Serialization(t *testing.T) {
	_, _, _, _, _, _, _, _, _, _, _, _, ds, _, _, lpt, _ := setupWaveformTest(t)
	w, err := New(ds, lpt)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer w.Close()
	jsonStr, err := w.ToJSON()
	if err != nil {
		t.Errorf("ToJSON error: %v", err)
	}
	w2, err := FromJSON(jsonStr)
	if err != nil {
		t.Errorf("FromJSON error: %v", err)
	}
	defer w2.Close()
	eq, err := w.Equal(w2)
	if err != nil || !eq {
		t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
	}
}
