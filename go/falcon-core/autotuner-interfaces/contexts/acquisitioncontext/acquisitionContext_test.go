package acquisitioncontext

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
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

func mustSymbolUnit() *symbolunit.Handle {
	h, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	return h
}

func TestAcquisitionContext_FullCoverage(t *testing.T) {
	conn := mustConnection()
	defer conn.Close()
	units := mustSymbolUnit()
	defer units.Close()
	port := mustInstrumentPort()
	defer port.Close()

	// New
	ac, err := New(conn, "type", units)
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer ac.Close()

	// NewFromPort
	ac2, err := NewFromPort(port)
	if err != nil {
		t.Fatalf("NewFromPort failed: %v", err)
	}
	defer ac2.Close()

	// CAPIHandle (open)
	ptr, err := ac.CAPIHandle()
	if err != nil || ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}

	// Connection
	gotConn, err := ac.Connection()
	if err != nil {
		t.Errorf("Connection failed: %v", err)
	}
	if gotConn != nil {
		gotConn.Close()
	}

	// InstrumentType
	gotType, err := ac.InstrumentType()
	if err != nil {
		t.Errorf("InstrumentType failed: %v", err)
	}
	if gotType != "type" {
		t.Errorf("InstrumentType got %q, want %q", gotType, "type")
	}

	// Units
	gotUnits, err := ac.Units()
	if err != nil {
		t.Errorf("Units failed: %v", err)
	}
	if gotUnits != nil {
		gotUnits.Close()
	}

	// DivisionUnit
	du, err := ac.DivisionUnit(units)
	if err != nil {
		t.Errorf("DivisionUnit failed: %v", err)
	}
	if du != nil {
		du.Close()
	}

	// Division
	div, err := ac.Division(ac2)
	if err != nil {
		t.Errorf("Division failed: %v", err)
	}
	if div != nil {
		div.Close()
	}

	// MatchConnection
	ok, err := ac.MatchConnection(conn)
	if err != nil {
		t.Errorf("MatchConnection failed: %v", err)
	}
	_ = ok

	// MatchInstrumentType
	ok, err = ac.MatchInstrumentType("type")
	if err != nil {
		t.Errorf("MatchInstrumentType failed: %v", err)
	}
	_ = ok

	// Equal
	eq, err := ac.Equal(ac2)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	_ = eq

	// NotEqual
	neq, err := ac.NotEqual(ac2)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	_ = neq

	// ToJSON/FromJSON
	jsonStr, err := ac.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	ac3, err := FromJSON(jsonStr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	if ac3 != nil {
		ac3.Close()
	}

	// Error branches
	ac.Close()
	_, err = ac.CAPIHandle()
	if err == nil {
		t.Errorf("CAPIHandle on closed should error")
	}
	err = ac.Close()
	if err == nil {
		t.Errorf("Second Close should error")
	}
	_, err = ac.Connection()
	if err == nil {
		t.Errorf("Connection on closed should error")
	}
	_, err = ac.InstrumentType()
	if err == nil {
		t.Errorf("InstrumentType on closed should error")
	}
	_, err = ac.Units()
	if err == nil {
		t.Errorf("Units on closed should error")
	}
	_, err = ac.DivisionUnit(units)
	if err == nil {
		t.Errorf("DivisionUnit on closed should error")
	}
	_, err = ac.Division(ac2)
	if err == nil {
		t.Errorf("Division on closed should error")
	}
	_, err = ac.MatchConnection(conn)
	if err == nil {
		t.Errorf("MatchConnection on closed should error")
	}
	_, err = ac.MatchInstrumentType("type")
	if err == nil {
		t.Errorf("MatchInstrumentType on closed should error")
	}
	_, err = ac.Equal(ac2)
	if err == nil {
		t.Errorf("Equal on closed should error")
	}
	_, err = ac.NotEqual(ac2)
	if err == nil {
		t.Errorf("NotEqual on closed should error")
	}
	_, err = ac.ToJSON()
	if err == nil {
		t.Errorf("ToJSON on closed should error")
	}
}
