package porttransform

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/analyticfunction"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestPort(t *testing.T) *instrumentport.Handle {
	conn, err := connection.NewBarrierGate("dummy")
	if err != nil {
		t.Fatalf("connection.NewBarrierGate error: %v", err)
	}
	unit, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("symbolunit.New error: %v", err)
	}
	p, err := instrumentport.NewKnob("P1", conn, "label", unit, "desc")
	if err != nil {
		t.Fatalf("instrumentport.NewKnob error: %v", err)
	}
	return p
}

func makeTestAnalyticFunction(t *testing.T) *analyticfunction.Handle {
	af, err := analyticfunction.NewConstant(2.0)
	if err != nil {
		t.Fatalf("analyticfunction.NewConstant error: %v", err)
	}
	return af
}

func makeTestArgs(t *testing.T) *mapstringdouble.Handle {
	m, err := mapstringdouble.NewEmpty()
	if err != nil {
		t.Fatalf("mapstringdouble.NewEmpty error: %v", err)
	}
	if err := m.InsertOrAssign("x", 1.0); err != nil {
		t.Fatalf("InsertOrAssign error: %v", err)
	}
	return m
}

func makeTestPortTransform(t *testing.T) (*Handle, *instrumentport.Handle, *analyticfunction.Handle) {
	port := makeTestPort(t)
	af := makeTestAnalyticFunction(t)
	pt, err := New(port, af)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	return pt, port, af
}

func TestPortTransform_NewAndClose(t *testing.T) {
	pt, port, af := makeTestPortTransform(t)
	defer port.Close()
	defer af.Close()
	if pt == nil {
		t.Fatal("New returned nil")
	}
	if err := pt.Close(); err != nil {
		t.Fatalf("Close error: %v", err)
	}
	if err := pt.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestPortTransform_NewConstantTransform(t *testing.T) {
	port := makeTestPort(t)
	defer port.Close()
	pt, err := NewConstantTransform(port, 5.0)
	if err != nil {
		t.Fatalf("NewConstantTransform error: %v", err)
	}
	defer pt.Close()
}

func TestPortTransform_NewIdentityTransform(t *testing.T) {
	port := makeTestPort(t)
	defer port.Close()
	pt, err := NewIdentityTransform(port)
	if err != nil {
		t.Fatalf("NewIdentityTransform error: %v", err)
	}
	defer pt.Close()
}

func TestPortTransform_Port(t *testing.T) {
	pt, port, af := makeTestPortTransform(t)
	defer pt.Close()
	defer port.Close()
	defer af.Close()
	p, err := pt.Port()
	if err != nil {
		t.Fatalf("Port error: %v", err)
	}
	if p == nil {
		t.Error("Port returned nil")
	}
	p.Close()
}

func TestPortTransform_Labels(t *testing.T) {
	pt, port, af := makeTestPortTransform(t)
	defer pt.Close()
	defer port.Close()
	defer af.Close()
	labels, err := pt.Labels()
	if err != nil {
		t.Fatalf("Labels error: %v", err)
	}
	if labels == nil {
		t.Error("Labels returned nil")
	}
	labels.Close()
}

func makeTestArgsForConstant(t *testing.T) *mapstringdouble.Handle {
	m, err := mapstringdouble.NewEmpty()
	if err != nil {
		t.Fatalf("mapstringdouble.NewEmpty error: %v", err)
	}
	return m
}

func TestPortTransform_Evaluate(t *testing.T) {
	pt, port, af := makeTestPortTransform(t)
	defer pt.Close()
	defer port.Close()
	defer af.Close()
	args := makeTestArgsForConstant(t)
	defer args.Close()
	val, err := pt.Evaluate(args, 0.0)
	if err != nil {
		t.Fatalf("Evaluate error: %v", err)
	}
	if val != 2.0 {
		t.Errorf("Evaluate = %v, want 2.0", val)
	}
}

func TestPortTransform_EvaluateArraywise(t *testing.T) {
	pt, port, af := makeTestPortTransform(t)
	defer pt.Close()
	defer port.Close()
	defer af.Close()
	args := makeTestArgsForConstant(t)
	defer args.Close()
	arr, err := pt.EvaluateArraywise(args, 1.0, 3.0)
	if err != nil {
		t.Fatalf("EvaluateArraywise error: %v", err)
	}
	if arr == nil {
		t.Error("EvaluateArraywise returned nil")
	}
	arr.Close()
}

func TestPortTransform_EqualAndNotEqual(t *testing.T) {
	pt1, port, af := makeTestPortTransform(t)
	defer pt1.Close()
	defer port.Close()
	defer af.Close()
	pt2, _, _ := makeTestPortTransform(t)
	defer pt2.Close()
	eq, err := pt1.Equal(pt2)
	if err != nil || !eq {
		t.Errorf("Equal = %v, want true, err: %v", eq, err)
	}
	neq, err := pt1.NotEqual(pt2)
	if err != nil || neq {
		t.Errorf("NotEqual = %v, want false, err: %v", neq, err)
	}
}

func TestPortTransform_ToJSONAndFromJSON(t *testing.T) {
	pt, port, af := makeTestPortTransform(t)
	defer pt.Close()
	defer port.Close()
	defer af.Close()
	jsonStr, err := pt.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON error: %v", err)
	}
	pt2, err := FromJSON(jsonStr)
	if err != nil {
		t.Fatalf("FromJSON error: %v", err)
	}
	defer pt2.Close()
	eq, err := pt.Equal(pt2)
	if err != nil || !eq {
		t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
	}
}

func TestPortTransform_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestPortTransform_FromCAPI_Valid(t *testing.T) {
	pt, port, af := makeTestPortTransform(t)
	defer pt.Close()
	defer port.Close()
	defer af.Close()
	capi, err := pt.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}

func TestPortTransform_ClosedErrors(t *testing.T) {
	pt, port, af := makeTestPortTransform(t)
	pt.Close()
	port.Close()
	af.Close()
	args := makeTestArgs(t)
	defer args.Close()
	if _, err := pt.Port(); err == nil {
		t.Error("Port() on closed: expected error")
	}
	if _, err := pt.Labels(); err == nil {
		t.Error("Labels() on closed: expected error")
	}
	if _, err := pt.Evaluate(args, 0.0); err == nil {
		t.Error("Evaluate() on closed: expected error")
	}
	if _, err := pt.EvaluateArraywise(args, 1.0, 3.0); err == nil {
		t.Error("EvaluateArraywise() on closed: expected error")
	}
	if _, err := pt.Equal(pt); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := pt.NotEqual(pt); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
	if _, err := pt.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := pt.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}
