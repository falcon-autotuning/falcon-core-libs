package interpretationcontext

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/measurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestSymbolUnit(t *testing.T) *symbolunit.Handle {
	u, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("symbolunit.New error: %v", err)
	}
	return u
}

func makeTestMeasurementContext(t *testing.T, name string) *measurementcontext.Handle {
	conn, _ := connection.NewBarrierGate(name)
	m, err := measurementcontext.New(conn, instrumenttypes.VoltageSource())
	if err != nil {
		t.Fatalf("measurementcontext.New(%q) error: %v", name, err)
	}
	return m
}

func makeTestAxesMeasurementContext(t *testing.T) *axesmeasurementcontext.Handle {
	names := []string{"x", "y"}
	var axes []*measurementcontext.Handle
	for _, n := range names {
		axes = append(axes, makeTestMeasurementContext(t, n))
	}
	a, err := axesmeasurementcontext.New(axes)
	if err != nil {
		t.Fatalf("axesmeasurementcontext.New error: %v", err)
	}
	return a
}

func makeTestListMeasurementContext(t *testing.T) *listmeasurementcontext.Handle {
	names := []string{"a", "b"}
	var out []*measurementcontext.Handle
	for _, n := range names {
		out = append(out, makeTestMeasurementContext(t, n))
	}
	l, err := listmeasurementcontext.New(out)
	if err != nil {
		t.Fatalf("listmeasurementcontext.New error: %v", err)
	}
	return l
}

func withInterpretationContext(t *testing.T, fn func(t *testing.T, ic *Handle, indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle)) {
	indep := makeTestAxesMeasurementContext(t)
	defer indep.Close()
	dep := makeTestListMeasurementContext(t)
	defer dep.Close()
	unit := makeTestSymbolUnit(t)
	defer unit.Close()
	ic, err := New(indep, dep, unit)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer ic.Close()
	fn(t, ic, indep, dep, unit)
}

func TestInterpretationContext_NewAndFields(t *testing.T) {
	withInterpretationContext(t, func(t *testing.T, ic *Handle, indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle) {
		gotIndep, err := ic.IndependentVariables()
		if err != nil {
			t.Fatalf("IndependentVariables error: %v", err)
		}
		defer gotIndep.Close()
		gotDep, err := ic.DependentVariables()
		if err != nil {
			t.Fatalf("DependentVariables error: %v", err)
		}
		defer gotDep.Close()
		gotUnit, err := ic.Unit()
		if err != nil {
			t.Fatalf("Unit error: %v", err)
		}
		defer gotUnit.Close()
		dim, err := ic.Dimension()
		if err != nil {
			t.Fatalf("Dimension error: %v", err)
		}
		if dim != 2 {
			t.Errorf("Dimension = %v, want 2", dim)
		}
	})
}

func TestInterpretationContext_AddReplaceDependentVariable(t *testing.T) {
	withInterpretationContext(t, func(t *testing.T, ic *Handle, indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle) {
		mc := makeTestMeasurementContext(t, "c")
		defer mc.Close()
		if err := ic.AddDependentVariable(mc); err != nil {
			t.Fatalf("AddDependentVariable error: %v", err)
		}
		if err := ic.ReplaceDependentVariable(0, mc); err != nil {
			t.Fatalf("ReplaceDependentVariable error: %v", err)
		}
	})
}

func TestInterpretationContext_GetIndependentVariable(t *testing.T) {
	withInterpretationContext(t, func(t *testing.T, ic *Handle, indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle) {
		mc, err := ic.GetIndependentVariable(0)
		if err != nil {
			t.Fatalf("GetIndependentVariable error: %v", err)
		}
		defer mc.Close()
	})
}

func TestInterpretationContext_WithUnit(t *testing.T) {
	withInterpretationContext(t, func(t *testing.T, ic *Handle, indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle) {
		newUnit := makeTestSymbolUnit(t)
		defer newUnit.Close()
		ic2, err := ic.WithUnit(newUnit)
		if err != nil {
			t.Fatalf("WithUnit error: %v", err)
		}
		defer ic2.Close()
	})
}

func TestInterpretationContext_EqualAndNotEqual(t *testing.T) {
	withInterpretationContext(t, func(t *testing.T, ic *Handle, indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle) {
		ic2, err := New(indep, dep, unit)
		if err != nil {
			t.Fatalf("New error: %v", err)
		}
		defer ic2.Close()
		eq, err := ic.Equal(ic2)
		if err != nil || !eq {
			t.Errorf("Equal = %v, want true, err: %v", eq, err)
		}
		neq, err := ic.NotEqual(ic2)
		if err != nil || neq {
			t.Errorf("NotEqual = %v, want false, err: %v", neq, err)
		}
	})
}

func TestInterpretationContext_ToJSONAndFromJSON(t *testing.T) {
	withInterpretationContext(t, func(t *testing.T, ic *Handle, indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle) {
		jsonStr, err := ic.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		ic2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer ic2.Close()
		eq, err := ic.Equal(ic2)
		if err != nil || !eq {
			t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
		}
	})
}

func TestInterpretationContext_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestInterpretationContext_CAPIHandle(t *testing.T) {
	withInterpretationContext(t, func(t *testing.T, ic *Handle, indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle) {
		ptr, err := ic.CAPIHandle()
		if err != nil {
			t.Errorf("CAPIHandle failed: %v", err)
		}
		if ptr == nil {
			t.Errorf("CAPIHandle returned nil")
		}
	})
}

func TestInterpretationContext_ClosedErrors(t *testing.T) {
	indep := makeTestAxesMeasurementContext(t)
	defer indep.Close()
	dep := makeTestListMeasurementContext(t)
	defer dep.Close()
	unit := makeTestSymbolUnit(t)
	defer unit.Close()
	ic, err := New(indep, dep, unit)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	ic.Close()
	if _, err := ic.CAPIHandle(); err == nil {
		t.Error("CAPIHandle on closed: expected error")
	}
	if err := ic.Close(); err == nil {
		t.Error("Second close should error")
	}
	if _, err := ic.IndependentVariables(); err == nil {
		t.Error("IndependentVariables on closed: expected error")
	}
	if _, err := ic.DependentVariables(); err == nil {
		t.Error("DependentVariables on closed: expected error")
	}
	if _, err := ic.Unit(); err == nil {
		t.Error("Unit on closed: expected error")
	}
	if _, err := ic.Dimension(); err == nil {
		t.Error("Dimension on closed: expected error")
	}
	mc := makeTestMeasurementContext(t, "z")
	defer mc.Close()
	if err := ic.AddDependentVariable(mc); err == nil {
		t.Error("AddDependentVariable on closed: expected error")
	}
	if err := ic.ReplaceDependentVariable(0, mc); err == nil {
		t.Error("ReplaceDependentVariable on closed: expected error")
	}
	if _, err := ic.GetIndependentVariable(0); err == nil {
		t.Error("GetIndependentVariable on closed: expected error")
	}
	if _, err := ic.WithUnit(unit); err == nil {
		t.Error("WithUnit on closed: expected error")
	}
	if _, err := ic.Equal(ic); err == nil {
		t.Error("Equal on closed: expected error")
	}
	if _, err := ic.NotEqual(ic); err == nil {
		t.Error("NotEqual on closed: expected error")
	}
	if _, err := ic.ToJSON(); err == nil {
		t.Error("ToJSON on closed: expected error")
	}
}
