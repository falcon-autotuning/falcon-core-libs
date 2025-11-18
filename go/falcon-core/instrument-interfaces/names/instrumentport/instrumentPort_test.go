package instrumentport

import (
	"errors"
	"testing"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestInputs(t *testing.T) (string, *connection.Handle, string, *symbolunit.Handle, string) {
	conn, err := connection.NewBarrierGate("testconn")
	if err != nil {
		t.Fatalf("failed to create connection: %v", err)
	}
	unit, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("failed to create symbolunit: %v", err)
	}
	return "foo", conn, "testtype", unit, "desc"
}

func TestInstrumentPort_ErrorOnClosed(t *testing.T) {
	name, conn, typ, unit, desc := makeTestInputs(t)
	p, err := NewPort(name, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	p.Close()
	p2, err := NewPort("bar", conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p2.Close()
	tests := []struct {
		name string
		test func() error
	}{
		{"DefaultName", func() error { _, err := p.DefaultName(); return err }},
		{"PsuedoName", func() error { _, err := p.PsuedoName(); return err }},
		{"InstrumentType", func() error { _, err := p.InstrumentType(); return err }},
		{"Units", func() error { _, err := p.Units(); return err }},
		{"Description", func() error { _, err := p.Description(); return err }},
		{"InstrumentFacingName", func() error { _, err := p.InstrumentFacingName(); return err }},
		{"IsKnob", func() error { _, err := p.IsKnob(); return err }},
		{"IsMeter", func() error { _, err := p.IsMeter(); return err }},
		{"IsPort", func() error { _, err := p.IsPort(); return err }},
		{"Equal", func() error { _, err := p.Equal(p2); return err }},
		{"NotEqual", func() error { _, err := p.NotEqual(p2); return err }},
		{"ToJSON", func() error { _, err := p.ToJSON(); return err }},
		{"Close", func() error { err := p.Close(); return err }},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			if err := tc.test(); err == nil {
				t.Errorf("Expected error from %s() on closed instrumentport", tc.name)
			}
		})
	}
}

func TestInstrumentPort_AccessorsReturnValues(t *testing.T) {
	name, conn, typ, unit, desc := makeTestInputs(t)
	p, err := NewPort(name, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p.Close()
	p2, err := NewPort(name, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p2.Close()
	p3, err := NewPort("bar", conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p3.Close()
	tests := []struct {
		name string
		test func(t *testing.T)
	}{
		{"DefaultName", func(t *testing.T) {
			got, err := p.DefaultName()
			if err != nil || got != name {
				t.Errorf("Expected name '%s', got '%s', err: %v", name, got, err)
			}
		}},
		{"InstrumentType", func(t *testing.T) {
			got, err := p.InstrumentType()
			if err != nil || got != typ {
				t.Errorf("Expected instrument type '%s', got '%s', err: %v", typ, got, err)
			}
		}},
		{"Units", func(t *testing.T) {
			units, err := p.Units()
			if err != nil || units == nil {
				t.Errorf("Expected non-nil units, got '%v', err: %v", units, err)
			}
			if units != nil {
				defer units.Close()
			}
		}},
		{"Description", func(t *testing.T) {
			got, err := p.Description()
			if err != nil || got != desc {
				t.Errorf("Expected description '%s', got '%s', err: %v", desc, got, err)
			}
		}},
		{"InstrumentFacingName", func(t *testing.T) {
			got, err := p.InstrumentFacingName()
			if err != nil || got == "" {
				t.Errorf("Expected non-empty instrument facing name, got '%s', err: %v", got, err)
			}
		}},
		{"IsKnob", func(t *testing.T) {
			val, err := p.IsKnob()
			if err != nil {
				t.Errorf("IsKnob error: %v", err)
			}
			if val {
				t.Error("Expected IsKnob false")
			}
		}},
		{"IsMeter", func(t *testing.T) {
			val, err := p.IsMeter()
			if err != nil {
				t.Errorf("IsMeter error: %v", err)
			}
			if val {
				t.Error("Expected IsMeter false")
			}
		}},
		{"IsPort", func(t *testing.T) {
			val, err := p.IsPort()
			if err != nil {
				t.Errorf("IsPort error: %v", err)
			}
			if !val {
				t.Error("Expected IsPort true")
			}
		}},
		{"Equal", func(t *testing.T) {
			eq, err := p.Equal(p2)
			if err != nil {
				t.Errorf("Equal error: %v", err)
			} else if !eq {
				t.Error("Expected Equal true")
			}
		}},
		{"NotEqual", func(t *testing.T) {
			neq, err := p.NotEqual(p3)
			if err != nil {
				t.Errorf("NotEqual error: %v", err)
			} else if !neq {
				t.Error("Expected NotEqual true")
			}
		}},
		{"ToJSON", func(t *testing.T) {
			js, err := p.ToJSON()
			if err != nil || js == "" {
				t.Errorf("Expected non-empty JSON, got '%s', err: %v", js, err)
			}
		}},
		{"PsuedoName", func(t *testing.T) {
			ps, err := p.PsuedoName()
			if err != nil {
				t.Errorf("PsuedoName error: %v", err)
			}
			if ps != nil {
				defer ps.Close()
			}
		}},
	}
	for _, tc := range tests {
		t.Run(tc.name, tc.test)
	}
}

func TestInstrumentPort_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestInstrumentPort_FromCAPI_Valid(t *testing.T) {
	name, conn, typ, unit, desc := makeTestInputs(t)
	p, err := NewPort(name, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p.Close()
	capi, err := p.CAPIHandle()
	if err != nil {
		t.Fatalf("unexpected error converting Port to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}

func TestInstrumentPort_Name_FromCAPIError(t *testing.T) {
	oldFromCAPI := stringFromCAPI
	stringFromCAPI = func(p unsafe.Pointer) (*str.Handle, error) {
		return nil, errors.New("simulated FromCAPI error")
	}
	defer func() { stringFromCAPI = oldFromCAPI }()
	name, conn, typ, unit, desc := makeTestInputs(t)
	p, err := NewPort(name, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p.Close()
	_, err = p.DefaultName()
	if err == nil || err.Error() != "simulated FromCAPI error" {
		t.Errorf("DefaultName() FromCAPI error not handled, got: %v", err)
	}
}

func TestInstrumentPort_AllConstructors_Coverage(t *testing.T) {
	name, conn, typ, unit, desc := makeTestInputs(t)
	constructors := []struct {
		name        string
		constructor func(string, *connection.Handle, string, *symbolunit.Handle, string) (*Handle, error)
	}{
		{"Port", NewPort},
		{"Knob", NewKnob},
		{"Meter", NewMeter},
	}
	for _, tc := range constructors {
		t.Run(tc.name, func(t *testing.T) {
			p, err := tc.constructor(name, conn, typ, unit, desc)
			if err != nil {
				t.Fatalf("%s returned error: %v", tc.name, err)
			}
			if p == nil {
				t.Fatalf("%s returned nil", tc.name)
			}
			defer p.Close()
			got, err := p.InstrumentType()
			if err != nil {
				t.Errorf("%s.InstrumentType() error: %v", tc.name, err)
			}
			if got != typ {
				t.Errorf("%s.InstrumentType() returned '%s', want '%s'", tc.name, got, typ)
			}
		})
	}
	t.Run("Timer", func(t *testing.T) {
		p, err := NewTimer()
		if err != nil {
			t.Fatalf("NewTimer error: %v", err)
		}
		defer p.Close()
	})
	t.Run("ExecutionClock", func(t *testing.T) {
		p, err := NewExecutionClock()
		if err != nil {
			t.Fatalf("NewExecutionClock error: %v", err)
		}
		defer p.Close()
	})
	t.Run("FromJSON", func(t *testing.T) {
		name, conn, typ, unit, desc := makeTestInputs(t)
		orig, err := NewPort(name, conn, typ, unit, desc)
		if err != nil {
			t.Fatalf("NewPort error: %v", err)
		}
		defer orig.Close()
		js, err := orig.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		p, err := FromJSON(js)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		if p == nil {
			t.Fatal("FromJSON returned nil")
		}
		defer p.Close()
	})
}
