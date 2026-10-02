package instrumentport

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/access"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrument"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentcharacteristic"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/porttype"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/scope"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestInputs(t *testing.T) (string, string, scope.Scope, access.Access, instrumentcharacteristic.InstrumentCharacteristic, porttype.PortType, *connection.Handle, instrument.Instrument, *symbolunit.Handle, string) {
	conn, err := connection.NewBarrierGate("testconn")
	if err != nil {
		t.Fatalf("failed to create connection: %v", err)
	}
	unit, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("failed to create symbolunit: %v", err)
	}
	return "foo", "inst1", scope.Global, access.Read, instrumentcharacteristic.InstrumentCharacteristicNone, porttype.PortTypeSetting, conn, instrument.DcCurrentSource, unit, "desc"
}

func TestInstrumentPort_ErrorOnClosed(t *testing.T) {
	name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc := makeTestInputs(t)
	p, err := NewPort(name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	p.Close()
	p2, err := NewPort("bar", inst, scope, access, characteristic, porttype, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p2.Close()
	tests := []struct {
		name string
		test func() error
	}{
		{"DefaultName", func() error { _, err := p.DefaultName(); return err }},
		{"InstrumentName", func() error { _, err := p.InstrumentName(); return err }},
		{"Scope", func() error { _, err := p.Scope(); return err }},
		{"Access", func() error { _, err := p.Access(); return err }},
		{"Characteristic", func() error { _, err := p.Characteristic(); return err }},
		{"Type", func() error { _, err := p.Type(); return err }},
		{"PsuedoName", func() error { _, err := p.PseudoName(); return err }},
		{"InstrumentType", func() error { _, err := p.InstrumentType(); return err }},
		{"Units", func() error { _, err := p.Units(); return err }},
		{"Description", func() error { _, err := p.Description(); return err }},
		{"InstrumentFacingName", func() error { _, err := p.InstrumentFacingName(); return err }},
		{"IsKnob", func() error { _, err := p.IsKnob(); return err }},
		{"IsMeter", func() error { _, err := p.IsMeter(); return err }},
		{"IsPort", func() error { _, err := p.IsSetting(); return err }},
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
	name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc := makeTestInputs(t)
	p, err := NewPort(name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p.Close()
	p2, err := NewPort(name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p2.Close()
	p3, err := NewPort("bar", inst, scope, access, characteristic, porttype, conn, typ, unit, desc)
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
		{
			"InstrumentName", func(t *testing.T) {
				got, err := p.InstrumentName()
				if err != nil || got != inst {
					t.Errorf("Expected instrument name '%s', got '%s', err: %v", inst, got, err)
				}
			},
		},
		{
			"Type", func(t *testing.T) {
				got, err := p.Type()
				if err != nil {
					t.Fatalf("Type error: %v", err)
				}
				if got != porttype {
					t.Fatalf("expected %v, got %v", porttype, got)
				}
			},
		},
		{
			"Characteristic", func(t *testing.T) {
				got, err := p.Characteristic()
				if err != nil {
					t.Fatalf("Characteristic error: %v", err)
				}
				if got != characteristic {
					t.Fatalf("expected %v, got %v", characteristic, got)
				}
			},
		},
		{
			"Access", func(t *testing.T) {
				got, err := p.Access()
				if err != nil {
					t.Fatalf("Access error: %v", err)
				}
				if got != access {
					t.Fatalf("expected %v, got %v", access, got)
				}
			},
		},
		{"Units", func(t *testing.T) {
			units, err := p.Units()
			if err != nil || units == nil {
				t.Errorf("Expected non-nil units, got '%v', err: %v", units, err)
			}
			if units != nil {
				defer units.Close()
			}
		}},
		{
			"Scope", func(t *testing.T) {
				got, err := p.Scope()
				if err != nil {
					t.Fatalf("Scope error: %v", err)
				}
				if got != scope {
					t.Fatalf("expected %v, got %v", scope, got)
				}
			},
		},
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
		{"IsSetting", func(t *testing.T) {
			val, err := p.IsSetting()
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
		{"PseudoName", func(t *testing.T) {
			ps, err := p.PseudoName()
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
	name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc := makeTestInputs(t)
	p, err := NewPort(name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc)
	if err != nil {
		t.Fatalf("unexpected error creating Port: %v", err)
	}
	defer p.Close()
	capi := p.CAPIHandle()
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}

func TestInstrumentPort_AllConstructors_Coverage(t *testing.T) {
	name, inst, scope, access, characteristic, _, conn, typ, unit, desc := makeTestInputs(t)

	constructors := []struct {
		name        string
		constructor func() (*Handle, error)
	}{
		{
			name: "Knob",
			constructor: func() (*Handle, error) {
				return NewKnob(name, inst, conn, typ, unit, desc)
			},
		},
		{
			name: "Meter",
			constructor: func() (*Handle, error) {
				return NewMeter(name, inst, conn, typ, unit, desc)
			},
		},
		{
			name: "Setting",
			constructor: func() (*Handle, error) {
				return NewSetting(
					name,
					inst,
					scope,
					access,
					characteristic,
					conn,
					typ,
					unit,
					desc,
				)
			},
		},
	}

	for _, tc := range constructors {
		t.Run(tc.name, func(t *testing.T) {
			p, err := tc.constructor()
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
		name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc := makeTestInputs(t)
		orig, err := NewPort(name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc)
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

func TestInstrumentPort_Copy(t *testing.T) {
	name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc := makeTestInputs(t)

	p, err := NewPort(
		name,
		inst,
		scope,
		access,
		characteristic,
		porttype,
		conn,
		typ,
		unit,
		desc,
	)
	if err != nil {
		t.Fatalf("NewPort error: %v", err)
	}
	defer p.Close()

	cp, err := Copy(p)
	if err != nil {
		t.Fatalf("Copy error: %v", err)
	}
	defer cp.Close()

	eq, err := p.Equal(cp)
	if err != nil {
		t.Fatalf("Equal error: %v", err)
	}

	if !eq {
		t.Fatal("expected copy to equal original")
	}
}

func TestInstrumentPort_CopyClosed(t *testing.T) {
	name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc := makeTestInputs(t)

	p, err := NewPort(
		name,
		inst,
		scope,
		access,
		characteristic,
		porttype,
		conn,
		typ,
		unit,
		desc,
	)
	if err != nil {
		t.Fatalf("NewPort error: %v", err)
	}

	p.Close()

	if _, err := Copy(p); err == nil {
		t.Fatal("expected error")
	}
}

func TestInstrumentPort_IsNil(t *testing.T) {
	var p *Handle

	if !p.IsNil() {
		t.Fatal("expected nil handle")
	}

	name, inst, scope, access, characteristic, porttype, conn, typ, unit, desc := makeTestInputs(t)

	h, err := NewPort(
		name,
		inst,
		scope,
		access,
		characteristic,
		porttype,
		conn,
		typ,
		unit,
		desc,
	)
	if err != nil {
		t.Fatalf("NewPort error: %v", err)
	}
	defer h.Close()

	if h.IsNil() {
		t.Fatal("expected non-nil handle")
	}
}
