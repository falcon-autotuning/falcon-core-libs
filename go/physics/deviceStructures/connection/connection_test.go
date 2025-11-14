package connection

import (
	"runtime"
	"testing"
)

func TestConnection_ErrorOnClosed(t *testing.T) {
	c := NewBarrierGate("foo")
	c.Close()
	c2 := NewBarrierGate("bar")
	defer c2.Close()

	tests := []struct {
		name string
		test func() error
	}{
		{"Name", func() error { _, err := c.Name(); return err }},
		{"Type", func() error { _, err := c.Type(); return err }},
		{"IsDotGate", func() error { _, err := c.IsDotGate(); return err }},
		{"IsBarrierGate", func() error { _, err := c.IsBarrierGate(); return err }},
		{"IsPlungerGate", func() error { _, err := c.IsPlungerGate(); return err }},
		{"IsReservoirGate", func() error { _, err := c.IsReservoirGate(); return err }},
		{"IsScreeningGate", func() error { _, err := c.IsScreeningGate(); return err }},
		{"IsOhmic", func() error { _, err := c.IsOhmic(); return err }},
		{"IsGate", func() error { _, err := c.IsGate(); return err }},
		{"Equal", func() error { _, err := c.Equal(c2); return err }},
		{"NotEqual", func() error { _, err := c.NotEqual(c2); return err }},
		{"ToJSON", func() error { _, err := c.ToJSON(); return err }},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			if err := tc.test(); err == nil {
				t.Errorf("Expected error from %s() on closed connection", tc.name)
			}
		})
	}
}

func TestConnection_AccessorsReturnValues(t *testing.T) {
	c := NewBarrierGate("foo")
	defer c.Close()
	c2 := NewBarrierGate("foo")
	defer c2.Close()
	c3 := NewBarrierGate("bar")
	defer c3.Close()

	tests := []struct {
		name string
		test func(t *testing.T)
	}{
		{"Name", func(t *testing.T) {
			name, err := c.Name()
			if err != nil || name != "foo" {
				t.Errorf("Expected name 'foo', got '%s', err: %v", name, err)
			}
		}},
		{"Type", func(t *testing.T) {
			typ, err := c.Type()
			if err != nil || typ != "BarrierGate" {
				t.Errorf("Expected type 'BarrierGate', got '%s', err: %v", typ, err)
			}
		}},
		{"IsDotGate", func(t *testing.T) {
			val, err := c.IsDotGate()
			if err != nil {
				t.Errorf("IsDotGate error: %v", err)
			} else if !val {
				t.Error("Expected IsDotGate true")
			}
		}},
		{"IsBarrierGate", func(t *testing.T) {
			val, err := c.IsBarrierGate()
			if err != nil {
				t.Errorf("IsBarrierGate error: %v", err)
			} else if !val {
				t.Error("Expected IsBarrierGate true")
			}
		}},
		{"IsPlungerGate", func(t *testing.T) {
			val, err := c.IsPlungerGate()
			if err != nil {
				t.Errorf("IsPlungerGate error: %v", err)
			} else if val {
				t.Error("Expected IsPlungerGate false")
			}
		}},
		{"IsReservoirGate", func(t *testing.T) {
			val, err := c.IsReservoirGate()
			if err != nil {
				t.Errorf("IsReservoirGate error: %v", err)
			} else if val {
				t.Error("Expected IsReservoirGate false")
			}
		}},
		{"IsScreeningGate", func(t *testing.T) {
			val, err := c.IsScreeningGate()
			if err != nil {
				t.Errorf("IsScreeningGate error: %v", err)
			} else if val {
				t.Error("Expected IsScreeningGate false")
			}
		}},
		{"IsOhmic", func(t *testing.T) {
			val, err := c.IsOhmic()
			if err != nil {
				t.Errorf("IsOhmic error: %v", err)
			} else if val {
				t.Error("Expected IsOhmic false")
			}
		}},
		{"IsGate", func(t *testing.T) {
			val, err := c.IsGate()
			if err != nil {
				t.Errorf("IsGate error: %v", err)
			} else if !val {
				t.Error("Expected IsGate true")
			}
		}},
		{"Equal", func(t *testing.T) {
			eq, err := c.Equal(c2)
			if err != nil {
				t.Errorf("Equal error: %v", err)
			} else if !eq {
				t.Error("Expected Equal true")
			}
		}},
		{"NotEqual", func(t *testing.T) {
			neq, err := c.NotEqual(c3)
			if err != nil {
				t.Errorf("NotEqual error: %v", err)
			} else if !neq {
				t.Error("Expected NotEqual true")
			}
		}},
		{"ToJSON", func(t *testing.T) {
			js, err := c.ToJSON()
			if err != nil || js == "" {
				t.Errorf("Expected non-empty JSON, got '%s', err: %v", js, err)
			}
		}},
	}

	for _, tc := range tests {
		t.Run(tc.name, tc.test)
	}
}

func TestConnection_ConstructorsAndAccessors_AllTypes(t *testing.T) {
	tests := []struct {
		name        string
		constructor func(string) *Connection
		wantType    string
		isFunc      func(*Connection) (bool, error)
	}{
		{"BarrierGate", NewBarrierGate, "BarrierGate", (*Connection).IsBarrierGate},
		{"PlungerGate", NewPlungerGate, "PlungerGate", (*Connection).IsPlungerGate},
		{"ReservoirGate", NewReservoirGate, "ReservoirGate", (*Connection).IsReservoirGate},
		{"ScreeningGate", NewScreeningGate, "ScreeningGate", (*Connection).IsScreeningGate},
		{"Ohmic", NewOhmic, "Ohmic", (*Connection).IsOhmic},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			c := tc.constructor("foo")
			defer c.Close()
			typ, err := c.Type()
			if err != nil || typ != tc.wantType {
				t.Errorf("Expected type %q, got %q, err: %v", tc.wantType, typ, err)
			}
			val, err := tc.isFunc(c)
			if err != nil {
				t.Errorf("%s feature check error: %v", tc.name, err)
			}
			if !val {
				t.Errorf("Expected %s feature to be true", tc.name)
			}
		})
	}
}

func TestConnection_FromJSON(t *testing.T) {
	orig := NewScreeningGate("foo")
	defer orig.Close()
	js, err := orig.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON error: %v", err)
	}
	c := ConnectionFromJSON(js)
	defer c.Close()
	name, err := c.Name()
	if err != nil || name != "foo" {
		t.Errorf("Expected name 'foo', got '%s', err: %v", name, err)
	}
	typ, err := c.Type()
	if err != nil || typ != "ScreeningGate" {
		t.Errorf("Expected type 'ScreeningGate', got '%s', err: %v", typ, err)
	}
}

func TestConnection_Close_Idempotent(t *testing.T) {
	c := NewBarrierGate("foo")
	if err := c.closeHandle(); err != nil {
		t.Errorf("First closeHandle should succeed, got err: %v", err)
	}
	if err := c.closeHandle(); err == nil {
		t.Error("Second closeHandle should fail (already closed), got nil error")
	}
}

func TestConnection_CleanupViaGC_AllConstructors(t *testing.T) {
	constructors := []struct {
		name        string
		constructor func() *Connection
	}{
		{"BarrierGate", func() *Connection { return NewBarrierGate("gc-test") }},
		{"PlungerGate", func() *Connection { return NewPlungerGate("gc-test") }},
		{"ReservoirGate", func() *Connection { return NewReservoirGate("gc-test") }},
		{"ScreeningGate", func() *Connection { return NewScreeningGate("gc-test") }},
		{"Ohmic", func() *Connection { return NewOhmic("gc-test") }},
		{"FromJSON", func() *Connection {
			orig := NewScreeningGate("gc-test")
			js, _ := orig.ToJSON()
			return ConnectionFromJSON(js)
		}},
	}

	for _, tc := range constructors {
		t.Run(tc.name, func(t *testing.T) {
			func() {
				_ = tc.constructor()
				// Do not call Close(), let the object go out of scope
			}()
			runtime.GC()
			runtime.Gosched()
			// Optionally, check for side effects if possible
		})
	}
}
