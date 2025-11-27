package rightreservoirwithimplantedohmic

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
)

func makeTestConnections(t *testing.T) (*connection.Handle, *connection.Handle) {
	left, err := connection.NewBarrierGate("left")
	if err != nil {
		t.Fatalf("NewBarrierGate (left) error: %v", err)
	}
	ohmic, err := connection.NewOhmic("ohmic")
	if err != nil {
		t.Fatalf("NewOhmic (ohmic) error: %v", err)
	}
	return left, ohmic
}

func TestRightReservoirWithImplantedOhmic_LifecycleAndAccessors(t *testing.T) {
	left, ohmic := makeTestConnections(t)
	rr, err := New("RR1", left, ohmic)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer rr.Close()

	t.Run("Name", func(t *testing.T) {
		name, err := rr.Name()
		if err != nil {
			t.Fatalf("Name() error: %v", err)
		}
		if name != "RR1" {
			t.Errorf("Name() = %v, want RR1", name)
		}
	})

	t.Run("Type", func(t *testing.T) {
		typ, err := rr.Type()
		if err != nil {
			t.Fatalf("Type() error: %v", err)
		}
		if typ == "" {
			t.Errorf("Type() returned empty string")
		}
	})

	t.Run("Ohmic", func(t *testing.T) {
		ohmicConn, err := rr.Ohmic()
		if err != nil {
			t.Fatalf("Ohmic() error: %v", err)
		}
		if ohmicConn == nil {
			t.Errorf("Ohmic() returned nil")
		}
	})

	t.Run("LeftNeighbor", func(t *testing.T) {
		leftConn, err := rr.LeftNeighbor()
		if err != nil {
			t.Fatalf("LeftNeighbor() error: %v", err)
		}
		if leftConn == nil {
			t.Errorf("LeftNeighbor() returned nil")
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := rr.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		rr2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer rr2.Close()
		name2, err := rr2.Name()
		if err != nil {
			t.Fatalf("FromJSON Name error: %v", err)
		}
		if name2 != "RR1" {
			t.Errorf("FromJSON/ToJSON roundtrip failed: got %v, want RR1", name2)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := rr.Equal(rr2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := rr.NotEqual(rr2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestRightReservoirWithImplantedOhmic_ClosedErrors(t *testing.T) {
	left, ohmic := makeTestConnections(t)
	rr, err := New("RR2", left, ohmic)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	rr.Close()
	if _, err := rr.Name(); err == nil {
		t.Error("Name() on closed: expected error")
	}
	if _, err := rr.Type(); err == nil {
		t.Error("Type() on closed: expected error")
	}
	if _, err := rr.Ohmic(); err == nil {
		t.Error("Ohmic() on closed: expected error")
	}
	if _, err := rr.LeftNeighbor(); err == nil {
		t.Error("LeftNeighbor() on closed: expected error")
	}
	if _, err := rr.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := rr.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
	other, err := New("RR3", left, ohmic)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer other.Close()
	if _, err := rr.Equal(other); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := rr.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
}

func TestRightReservoirWithImplantedOhmic_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestRightReservoirWithImplantedOhmic_FromCAPI_Valid(t *testing.T) {
	left, ohmic := makeTestConnections(t)
	rr, err := New("RR4", left, ohmic)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer rr.Close()
	capi := rr.CAPIHandle()
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
