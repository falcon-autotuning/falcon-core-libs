package labelleddomain

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustConnection() *connection.Handle {
	h, err := connection.NewBarrierGate("conn_id")
	if err != nil {
		panic(err)
	}
	return h
}

func mustInstrumentPort() *instrumentport.Handle {
	v, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	conn, err := connection.NewBarrierGate("conn_id")
	if err != nil {
		panic(err)
	}
	h, err := instrumentport.NewKnob("port_id", conn, instrumenttypes.VoltageSource(), v, "A test port")
	if err != nil {
		panic(err)
	}
	return h
}

func mustDomain() *domain.Handle {
	h, err := domain.New(0, 10, true, true)
	if err != nil {
		panic(err)
	}
	return h
}

func mustSymbolUnit() *symbolunit.Handle {
	h, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	return h
}

func TestLabelledDomain_FullCoverage(t *testing.T) {
	conn := mustConnection()
	defer conn.Close()
	port := mustInstrumentPort()
	defer port.Close()
	dom := mustDomain()
	defer dom.Close()
	units := mustSymbolUnit()
	defer units.Close()

	// NewPrimitiveKnob
	ld, err := NewPrimitiveKnob("knob", 0, 10, conn, "type", true, true, units, "desc")
	if err != nil {
		t.Fatalf("NewPrimitiveKnob failed: %v", err)
	}
	defer ld.Close()

	// NewPrimitiveMeter
	ld2, err := NewPrimitiveMeter("meter", 0, 10, conn, "type", true, true, units, "desc")
	if err != nil {
		t.Fatalf("NewPrimitiveMeter failed: %v", err)
	}
	defer ld2.Close()

	// NewPrimitivePort
	ld3, err := NewPrimitivePort("port", 0, 10, conn, "type", true, true, units, "desc")
	if err != nil {
		t.Fatalf("NewPrimitivePort failed: %v", err)
	}
	defer ld3.Close()

	// NewFromPort
	ld4, err := NewFromPort(0, 10, port, true, true)
	if err != nil {
		t.Fatalf("NewFromPort failed: %v", err)
	}
	defer ld4.Close()

	// NewFromPortAndDomain
	ld5, err := NewFromPortAndDomain(port, dom)
	if err != nil {
		t.Fatalf("NewFromPortAndDomain failed: %v", err)
	}
	defer ld5.Close()

	// NewFromDomain
	ld6, err := NewFromDomain(dom, "name", conn, "type", units, "desc")
	if err != nil {
		t.Fatalf("NewFromDomain failed: %v", err)
	}
	defer ld6.Close()

	// CAPIHandle (open)
	ptr := ld.CAPIHandle()
	if ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}

	// Port
	gotPort, err := ld.Port()
	if err != nil {
		t.Errorf("Port failed: %v", err)
	}
	if gotPort != nil {
		gotPort.Close()
	}

	// Domain
	gotDom, err := ld.Domain()
	if err != nil {
		t.Errorf("Domain failed: %v", err)
	}
	if gotDom != nil {
		gotDom.Close()
	}

	// MatchingPort
	ok, err := ld.MatchingPort(port)
	if err != nil {
		t.Errorf("MatchingPort failed: %v", err)
	}
	_ = ok

	// LesserBound
	_, err = ld.LesserBound()
	if err != nil {
		t.Errorf("LesserBound failed: %v", err)
	}

	// GreaterBound
	_, err = ld.GreaterBound()
	if err != nil {
		t.Errorf("GreaterBound failed: %v", err)
	}

	// LesserBoundContained
	_, err = ld.LesserBoundContained()
	if err != nil {
		t.Errorf("LesserBoundContained failed: %v", err)
	}

	// GreaterBoundContained
	_, err = ld.GreaterBoundContained()
	if err != nil {
		t.Errorf("GreaterBoundContained failed: %v", err)
	}

	// In
	_, err = ld.In(5)
	if err != nil {
		t.Errorf("In failed: %v", err)
	}

	// Range
	_, err = ld.Range()
	if err != nil {
		t.Errorf("Range failed: %v", err)
	}

	// Center
	_, err = ld.Center()
	if err != nil {
		t.Errorf("Center failed: %v", err)
	}

	// Intersection
	ld7, err := ld.Intersection(ld2)
	if err != nil {
		t.Errorf("Intersection failed: %v", err)
	}
	if ld7 != nil {
		ld7.Close()
	}

	// Union
	ld8, err := ld.Union(ld2)
	if err != nil {
		t.Errorf("Union failed: %v", err)
	}
	if ld8 != nil {
		ld8.Close()
	}

	// IsEmpty
	_, err = ld.IsEmpty()
	if err != nil {
		t.Errorf("IsEmpty failed: %v", err)
	}

	// ContainsDomain
	_, err = ld.ContainsDomain(ld2)
	if err != nil {
		t.Errorf("ContainsDomain failed: %v", err)
	}

	// Shift
	ld9, err := ld.Shift(1.0)
	if err != nil {
		t.Errorf("Shift failed: %v", err)
	}
	if ld9 != nil {
		ld9.Close()
	}

	// Scale
	ld10, err := ld.Scale(2.0)
	if err != nil {
		t.Errorf("Scale failed: %v", err)
	}
	if ld10 != nil {
		ld10.Close()
	}

	// Transform
	_, err = ld.Transform(ld2, 5.0)
	if err != nil {
		t.Errorf("Transform failed: %v", err)
	}

	// Equal
	_, err = ld.Equal(ld2)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}

	// NotEqual
	_, err = ld.NotEqual(ld2)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}

	// ToJSON/FromJSON
	jsonStr, err := ld.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	ld11, err := FromJSON(jsonStr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	if ld11 != nil {
		ld11.Close()
	}

	// Error branches
	ld.Close()
	err = ld.Close()
	if err == nil {
		t.Errorf("Second Close should error")
	}
	_, err = ld.Port()
	if err == nil {
		t.Errorf("Port on closed should error")
	}
	_, err = ld.Domain()
	if err == nil {
		t.Errorf("Domain on closed should error")
	}
	_, err = ld.MatchingPort(port)
	if err == nil {
		t.Errorf("MatchingPort on closed should error")
	}
	_, err = ld.LesserBound()
	if err == nil {
		t.Errorf("LesserBound on closed should error")
	}
	_, err = ld.GreaterBound()
	if err == nil {
		t.Errorf("GreaterBound on closed should error")
	}
	_, err = ld.LesserBoundContained()
	if err == nil {
		t.Errorf("LesserBoundContained on closed should error")
	}
	_, err = ld.GreaterBoundContained()
	if err == nil {
		t.Errorf("GreaterBoundContained on closed should error")
	}
	_, err = ld.In(5)
	if err == nil {
		t.Errorf("In on closed should error")
	}
	_, err = ld.Range()
	if err == nil {
		t.Errorf("Range on closed should error")
	}
	_, err = ld.Center()
	if err == nil {
		t.Errorf("Center on closed should error")
	}
	_, err = ld.Intersection(ld2)
	if err == nil {
		t.Errorf("Intersection on closed should error")
	}
	_, err = ld.Union(ld2)
	if err == nil {
		t.Errorf("Union on closed should error")
	}
	_, err = ld.IsEmpty()
	if err == nil {
		t.Errorf("IsEmpty on closed should error")
	}
	_, err = ld.ContainsDomain(ld2)
	if err == nil {
		t.Errorf("ContainsDomain on closed should error")
	}
	_, err = ld.Shift(1.0)
	if err == nil {
		t.Errorf("Shift on closed should error")
	}
	_, err = ld.Scale(2.0)
	if err == nil {
		t.Errorf("Scale on closed should error")
	}
	_, err = ld.Transform(ld2, 5.0)
	if err == nil {
		t.Errorf("Transform on closed should error")
	}
	_, err = ld.Equal(ld2)
	if err == nil {
		t.Errorf("Equal on closed should error")
	}
	_, err = ld.NotEqual(ld2)
	if err == nil {
		t.Errorf("NotEqual on closed should error")
	}
	_, err = ld.ToJSON()
	if err == nil {
		t.Errorf("ToJSON on closed should error")
	}
}
