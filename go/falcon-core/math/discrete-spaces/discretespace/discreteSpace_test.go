package discretespace

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesinstrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/unitspace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestUnitSpace(t *testing.T) *unitspace.Handle {
	u, err := unitspace.New(makeTestAxesDiscretizer(t), makeTestDomain(t))
	if err != nil {
		t.Fatalf("unitspace.New error: %v", err)
	}
	return u
}

func makeTestDiscretizer(t *testing.T) *discretizer.Handle {
	a, err := discretizer.NewCartesian(0.2)
	if err != nil {
		t.Fatalf("discretizer.NewEmpty error: %v", err)
	}
	return a
}

func makeTestAxesDiscretizer(t *testing.T) *axesdiscretizer.Handle {
	a, err := axesdiscretizer.New([]*discretizer.Handle{makeTestDiscretizer(t)})
	if err != nil {
		t.Fatalf("axesdiscretizer.NewEmpty error: %v", err)
	}
	return a
}

func makeTestAxesCoupledLabelledDomain(t *testing.T) *axescoupledlabelleddomain.Handle {
	a, err := axescoupledlabelleddomain.NewEmpty()
	if err != nil {
		t.Fatalf("axescoupledlabelleddomain.NewEmpty error: %v", err)
	}
	a.PushBack(makeTestCoupledLabelledDomain(t))
	return a
}

func makeTestCoupledLabelledDomain(t *testing.T) *coupledlabelleddomain.Handle {
	h, err := coupledlabelleddomain.New([]*labelleddomain.Handle{makeLabelledDomain(t)})
	if err != nil {
		t.Fatalf("coupled labelled domain failed: %v", err)
	}
	return h
}

func makePlungerGate(t *testing.T) *connection.Handle {
	h, err := connection.NewPlungerGate("P1")
	if err != nil {
		t.Fatalf("Unable to make plunger gate: %v", err)
	}
	return h
}

func makeLabelledDomain(t *testing.T) *labelleddomain.Handle {
	v, _ := symbolunit.NewVolt()
	h, err := labelleddomain.NewFromDomain(makeTestDomain(t), "P1", makePlungerGate(t), instrumenttypes.VoltageSource(), v, "")
	if err != nil {
		t.Fatalf("failed to make a labelleddomain: %v", err)
	}
	return h
}

func makeAxesInstrumentPort(t *testing.T) *axesinstrumentport.Handle {
	v, _ := symbolunit.NewVolt()
	ip, _ := instrumentport.NewKnob("P1", makePlungerGate(t), instrumenttypes.VoltageSource(), v, "")
	h, err := axesinstrumentport.New([]*instrumentport.Handle{ip})
	if err != nil {
		t.Fatalf("could not set up instrumentport axes")
	}
	return h
}

func makeTestAxesMapStringBool(t *testing.T) *axesmapstringbool.Handle {
	a, err := axesmapstringbool.NewEmpty()
	if err != nil {
		t.Fatalf("axesmapstringbool.NewEmpty error: %v", err)
	}
	p, _ := pairstringbool.New("P1", true)
	m, _ := mapstringbool.New([]*pairstringbool.Handle{p})
	a.PushBack(m)
	return a
}

func makeTestDomain(t *testing.T) *domain.Handle {
	d, err := domain.New(0, 1, true, true)
	if err != nil {
		t.Fatalf("domain.New error: %v", err)
	}
	return d
}

func makeTestAxesInt(t *testing.T) *axesint.Handle {
	a, err := axesint.NewEmpty()
	if err != nil {
		t.Fatalf("axesint.NewEmpty error: %v", err)
	}
	a.PushBack(int32(1))
	return a
}

func makeTestMapStringBool(t *testing.T) *mapstringbool.Handle {
	m, err := mapstringbool.NewEmpty()
	if err != nil {
		t.Fatalf("mapstringbool.NewEmpty error: %v", err)
	}
	return m
}

func withDiscreteSpace(t *testing.T, fn func(t *testing.T, ds *Handle)) {
	space := makeTestUnitSpace(t)
	defer space.Close()
	axes := makeTestAxesCoupledLabelledDomain(t)
	defer axes.Close()
	incr := makeTestAxesMapStringBool(t)
	defer incr.Close()
	ds, err := New(space, axes, incr)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer ds.Close()
	fn(t, ds)
}

func TestDiscreteSpace_NewAndFields(t *testing.T) {
	withDiscreteSpace(t, func(t *testing.T, ds *Handle) {
		space, err := ds.Space()
		if err != nil {
			t.Fatalf("Space error: %v", err)
		}
		defer space.Close()
		axes, err := ds.Axes()
		if err != nil {
			t.Fatalf("Axes error: %v", err)
		}
		defer axes.Close()
		incr, err := ds.Increasing()
		if err != nil {
			t.Fatalf("Increasing error: %v", err)
		}
		defer incr.Close()
		knobs, err := ds.Knobs()
		if err != nil {
			t.Fatalf("Knobs error: %v", err)
		}
		defer knobs.Close()
	})
}

func TestDiscreteSpace_NewCartesian(t *testing.T) {
	div := makeTestAxesInt(t)
	s, err := div.Size()
	if err != nil {
		t.Error("An error happening getting the size of the instrumentport axes")
	}
	if s != 1 {
		t.Error("THe test axes instrument port aren't size 1")
	}
	defer div.Close()
	axes := makeTestAxesCoupledLabelledDomain(t)
	s, err = axes.Size()
	if err != nil {
		t.Error("An error happening getting the size of the coupled labelleddomain axes")
	}
	if s != 1 {
		t.Error("THe test axes coupled labelleddomain aren't size 1")
	}
	defer axes.Close()
	incr := makeTestAxesMapStringBool(t)
	s, err = incr.Size()
	if err != nil {
		t.Error("An error happening getting the size of the map string bool axes")
	}
	if s != 1 {
		t.Error("THe test axes map string bool aren't size 1")
	}
	defer incr.Close()
	dom := makeTestDomain(t)
	defer dom.Close()
	ds, err := NewCartesian(div, axes, incr, dom)
	if err != nil {
		t.Fatalf("NewCartesian error: %v", err)
	}
	defer ds.Close()
}

func TestDiscreteSpace_NewCartesian1D(t *testing.T) {
	shared := makeTestCoupledLabelledDomain(t)
	defer shared.Close()
	incr := makeTestMapStringBool(t)
	defer incr.Close()
	dom := makeTestDomain(t)
	defer dom.Close()
	ds, err := NewCartesian1D(5, shared, incr, dom)
	if err != nil {
		t.Fatalf("NewCartesian1D error: %v", err)
	}
	defer ds.Close()
}

func TestDiscreteSpace_ValidateMethods(t *testing.T) {
	withDiscreteSpace(t, func(t *testing.T, ds *Handle) {
		if err := ds.ValidateUnitSpaceDimensionalityMatchesKnobs(); err != nil {
			t.Errorf("ValidateUnitSpaceDimensionalityMatchesKnobs error: %v", err)
		}
		if err := ds.ValidateKnobUniqueness(); err != nil {
			t.Errorf("ValidateKnobUniqueness error: %v", err)
		}
	})
}

func TestDiscreteSpace_GetAxisAndDomain(t *testing.T) {
	withDiscreteSpace(t, func(t *testing.T, ds *Handle) {
		knobs, err := ds.Knobs()
		if err != nil {
			t.Fatalf("Knobs error: %v", err)
		}
		defer knobs.Close()
		_, err = ds.GetAxis(nil)
		if err == nil {
			t.Error("GetAxis(nil) should error")
		}
		_, err = ds.GetDomain(nil)
		if err == nil {
			t.Error("GetDomain(nil) should error")
		}
	})
}

func TestDiscreteSpace_GetProjection(t *testing.T) {
	withDiscreteSpace(t, func(t *testing.T, ds *Handle) {
		proj := makeAxesInstrumentPort(t)
		defer proj.Close()
		_, err := ds.GetProjection(proj)
		if err != nil {
			t.Errorf("Bad projection: %v", err)
		}
	})
}

func TestDiscreteSpace_EqualAndNotEqual(t *testing.T) {
	withDiscreteSpace(t, func(t *testing.T, ds *Handle) {
		space := makeTestUnitSpace(t)
		defer space.Close()
		axes := makeTestAxesCoupledLabelledDomain(t)
		defer axes.Close()
		incr := makeTestAxesMapStringBool(t)
		defer incr.Close()
		ds2, err := New(space, axes, incr)
		if err != nil {
			t.Fatalf("New error: %v", err)
		}
		defer ds2.Close()
		eq, err := ds.Equal(ds2)
		if err != nil {
			t.Errorf("Equal error: %v", err)
		}
		if !eq {
			t.Errorf("Expected equality")
		}
		neq, err := ds.NotEqual(ds2)
		if err != nil {
			t.Errorf("NotEqual error: %v", err)
		}
		if neq {
			t.Errorf("Expected not not equality")
		}
		// Should not panic if ds2 is nil
		_, err = ds.Equal(nil)
		if err == nil {
			t.Error("Equal(nil) should error")
		}
		_, err = ds.NotEqual(nil)
		if err == nil {
			t.Error("NotEqual(nil) should error")
		}
	})
}

func TestDiscreteSpace_ToJSONAndFromJSON(t *testing.T) {
	withDiscreteSpace(t, func(t *testing.T, ds *Handle) {
		jsonStr, err := ds.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		ds2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer ds2.Close()
		eq, err := ds.Equal(ds2)
		if err != nil || !eq {
			t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
		}
	})
}

func TestDiscreteSpace_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestDiscreteSpace_CAPIHandle(t *testing.T) {
	withDiscreteSpace(t, func(t *testing.T, ds *Handle) {
		ptr, err := ds.CAPIHandle()
		if err != nil {
			t.Errorf("CAPIHandle failed: %v", err)
		}
		if ptr == nil {
			t.Errorf("CAPIHandle returned nil")
		}
	})
}

func TestDiscreteSpace_ClosedErrors(t *testing.T) {
	space := makeTestUnitSpace(t)
	defer space.Close()
	axes := makeTestAxesCoupledLabelledDomain(t)
	defer axes.Close()
	incr := makeTestAxesMapStringBool(t)
	defer incr.Close()
	ds, err := New(space, axes, incr)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	ds.Close()
	if _, err := ds.CAPIHandle(); err == nil {
		t.Error("CAPIHandle on closed: expected error")
	}
	if err := ds.Close(); err == nil {
		t.Error("Second close should error")
	}
	if _, err := ds.Space(); err == nil {
		t.Error("Space on closed: expected error")
	}
	if _, err := ds.Axes(); err == nil {
		t.Error("Axes on closed: expected error")
	}
	if _, err := ds.Increasing(); err == nil {
		t.Error("Increasing on closed: expected error")
	}
	if _, err := ds.Knobs(); err == nil {
		t.Error("Knobs on closed: expected error")
	}
	if err := ds.ValidateUnitSpaceDimensionalityMatchesKnobs(); err == nil {
		t.Error("ValidateUnitSpaceDimensionalityMatchesKnobs on closed: expected error")
	}
	if err := ds.ValidateKnobUniqueness(); err == nil {
		t.Error("ValidateKnobUniqueness on closed: expected error")
	}
	if _, err := ds.GetAxis(nil); err == nil {
		t.Error("GetAxis on closed: expected error")
	}
	if _, err := ds.GetDomain(nil); err == nil {
		t.Error("GetDomain on closed: expected error")
	}
	if _, err := ds.GetProjection(nil); err == nil {
		t.Error("GetProjection on closed: expected error")
	}
	if _, err := ds.Equal(ds); err == nil {
		t.Error("Equal on closed: expected error")
	}
	if _, err := ds.NotEqual(ds); err == nil {
		t.Error("NotEqual on closed: expected error")
	}
	if _, err := ds.ToJSON(); err == nil {
		t.Error("ToJSON on closed: expected error")
	}
}
