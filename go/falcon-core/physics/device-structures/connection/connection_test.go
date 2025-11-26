package connection

import (
	"fmt"
	"testing"
)

func TestConnection_ErrorOnClosed(t *testing.T) {
	c, err := NewBarrierGate("foo")
	if err != nil {
		t.Fatalf("unexpected error creating BarrierGate: %v", err)
	}
	err = c.Close()
	if err != nil {
		t.Fatalf("unexpected error closing BarrierGate: %v", err)
	}
	c2, err := NewBarrierGate("bar")
	if err != nil {
		t.Fatalf("unexpected error creating BarrierGate: %v", err)
	}
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
		{"Close", func() error { err := c.Close(); return err }},
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
	c, err := NewBarrierGate("foo")
	if err != nil {
		t.Fatalf("unexpected error creating BarrierGate: %v", err)
	}
	fmt.Printf("Finished allocating NewBarrierGate\n")
	defer c.Close()
	c2, err := NewBarrierGate("foo")
	if err != nil {
		t.Fatalf("unexpected error creating BarrierGate: %v", err)
	}
	defer c2.Close()
	c3, err := NewBarrierGate("bar")
	if err != nil {
		t.Fatalf("unexpected error creating BarrierGate: %v", err)
	}
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

func TestConnection_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestConnection_FromCAPI_Valid(t *testing.T) {
	c, err := NewBarrierGate("foo")
	if err != nil {
		t.Fatalf("unexpected error creating BarrierGate: %v", err)
	}
	defer c.Close()
	capi := c.CAPIHandle()
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}

func TestConnection_AllConstructors_Coverage(t *testing.T) {
	gates := []struct {
		name        string
		constructor func(string) (*Handle, error)
	}{
		{"PlungerGate", NewPlungerGate},
		{"ReservoirGate", NewReservoirGate},
		{"ScreeningGate", NewScreeningGate},
		{"Ohmic", NewOhmic},
	}
	for _, tc := range gates {
		t.Run(tc.name, func(t *testing.T) {
			c, err := tc.constructor("foo")
			if err != nil {
				t.Fatalf("%s returned error: %v", tc.name, err)
			}
			if c == nil {
				t.Fatalf("%s returned nil", tc.name)
			}
			defer c.Close()
			typ, err := c.Type()
			if err != nil {
				t.Errorf("%s.Type() error: %v", tc.name, err)
			}
			if typ == "" {
				t.Errorf("%s.Type() returned empty string", tc.name)
			}
		})
	}
	t.Run("FromJSON", func(t *testing.T) {
		orig, err := NewScreeningGate("foo")
		if err != nil {
			t.Fatalf("NewScreeningGate error: %v", err)
		}
		defer orig.Close()
		js, err := orig.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		c, err := FromJSON(js)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		if c == nil {
			t.Fatal("FromJSON returned nil")
		}
		defer c.Close()
	})
}
