package impedance

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

func TestImpedance_LifecycleAndAccessors(t *testing.T) {
	conn, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf("NewBarrierGate error: %v", err)
	}
	imp, err := New(conn, 123.4, 56.7)
	if err != nil {
		t.Fatalf("Impedance New error: %v", err)
	}
	defer imp.Close()

	t.Run("Connection", func(t *testing.T) {
		gotConn, err := imp.Connection()
		if err != nil {
			t.Fatalf("Connection() error: %v", err)
		}
		if gotConn == nil {
			t.Fatalf("Connection() returned nil")
		}
	})

	t.Run("Resistance", func(t *testing.T) {
		res, err := imp.Resistance()
		if err != nil {
			t.Fatalf("Resistance() error: %v", err)
		}
		if res != 123.4 {
			t.Errorf("Resistance() = %v, want 123.4", res)
		}
	})

	t.Run("Capacitance", func(t *testing.T) {
		cap, err := imp.Capacitance()
		if err != nil {
			t.Fatalf("Capacitance() error: %v", err)
		}
		if cap != 56.7 {
			t.Errorf("Capacitance() = %v, want 56.7", cap)
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := imp.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		imp2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("ImpedanceFromJSON error: %v", err)
		}
		defer imp2.Close()
		res2, err := imp2.Resistance()
		if err != nil {
			t.Fatalf("ImpedanceFromJSON Resistance error: %v", err)
		}
		cap2, err := imp2.Capacitance()
		if err != nil {
			t.Fatalf("ImpedanceFromJSON Capacitance error: %v", err)
		}
		if res2 != 123.4 || cap2 != 56.7 {
			t.Errorf("ImpedanceFromJSON/ToJSON roundtrip failed: got (%v,%v), want (123.4,56.7)", res2, cap2)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := imp.Equal(imp2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := imp.NotEqual(imp2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestImpedance_ClosedErrors(t *testing.T) {
	conn, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf("NewBarrierGate error: %v", err)
	}
	imp, err := New(conn, 1, 1)
	if err != nil {
		t.Fatalf("Impedance New error: %v", err)
	}
	imp.Close()
	if _, err := imp.Connection(); err == nil {
		t.Error("Connection() on closed impedance: expected error")
	}
	if _, err := imp.Resistance(); err == nil {
		t.Error("Resistance() on closed impedance: expected error")
	}
	if _, err := imp.Capacitance(); err == nil {
		t.Error("Capacitance() on closed impedance: expected error")
	}
	if _, err := imp.ToJSON(); err == nil {
		t.Error("ToJSON() on closed impedance: expected error")
	}
	if err := imp.Close(); err == nil {
		t.Error("Close() on closed impedance: expected error")
	}
	other, err := New(conn, 2, 2)
	if err != nil {
		t.Fatalf("Impedance New error: %v", err)
	}
	defer other.Close()
	if _, err := imp.Equal(other); err == nil {
		t.Error("Equal() on closed impedance: expected error")
	}
	if _, err := imp.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed impedance: expected error")
	}
}

func TestImpedance_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestImpedance_FromCAPI_Valid(t *testing.T) {
	conn, err := connection.NewBarrierGate("foo")
	if err != nil {
		t.Fatalf("NewBarrierGate error: %v", err)
	}
	imp, err := New(conn, 1, 1)
	if err != nil {
		t.Fatalf("Impedance New error: %v", err)
	}
	defer imp.Close()
	capi, err := imp.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert impedance to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
