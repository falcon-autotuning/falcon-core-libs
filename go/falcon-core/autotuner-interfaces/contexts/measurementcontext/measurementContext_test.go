package measurementcontext

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
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

func TestMeasurementContext_FullCoverage(t *testing.T) {
	conn := mustConnection()
	defer conn.Close()
	instrType := "test_type"

	// Test New
	mc, err := New(conn, instrType)
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer mc.Close()

	// Test CAPIHandle (open)
	ptr := mc.CAPIHandle()
	if ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}

	// Test Connection
	gotConn, err := mc.Connection()
	if err != nil {
		t.Errorf("Connection failed: %v", err)
	}
	if gotConn == nil {
		t.Errorf("Connection returned nil")
	} else {
		gotConn.Close()
	}

	// Test InstrumentType
	gotType, err := mc.InstrumentType()
	if err != nil {
		t.Errorf("InstrumentType failed: %v", err)
	}
	if gotType != instrType {
		t.Errorf("InstrumentType got %q, want %q", gotType, instrType)
	}

	// Test ToJSON and FromJSON
	jsonStr, err := mc.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	mc2, err := FromJSON(jsonStr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	defer mc2.Close()

	// Test Equal/NotEqual
	eq, err := mc.Equal(mc2)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	if !eq {
		t.Errorf("Expected Equal true")
	}
	neq, err := mc.NotEqual(mc2)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	if neq {
		t.Errorf("Expected NotEqual false")
	}

	// Test NotEqual with nil/closed
	neq, err = mc.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual with nil should error")
	}
	mc2.Close()
	neq, err = mc.NotEqual(mc2)
	if err == nil {
		t.Errorf("NotEqual with closed should error")
	}

	// Test Equal with nil/closed
	_, err = mc.Equal(nil)
	if err == nil {
		t.Errorf("Equal with nil should error")
	}
	_, err = mc.Equal(mc2)
	if err == nil {
		t.Errorf("Equal with closed should error")
	}

	// Test CAPIHandle (closed)
	mc.Close()
	// Test Close twice
	err = mc.Close()
	if err == nil {
		t.Errorf("Second Close should error")
	}
}

func TestMeasurementContext_NewFromPort(t *testing.T) {
	port := mustInstrumentPort()
	defer port.Close()
	mc, err := NewFromPort(port)
	if err != nil {
		t.Fatalf("NewFromPort failed: %v", err)
	}
	defer mc.Close()
	// Just check it's not nil and can be closed
	if mc == nil {
		t.Errorf("NewFromPort returned nil")
	}
}
