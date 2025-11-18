package leftreservoirwithimplantedohmic

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

func makeTestConnections(t *testing.T) (*connection.Handle, *connection.Handle) {
	right, err := connection.NewBarrierGate("right")
	if err != nil {
		t.Fatalf("NewBarrierGate (right) error: %v", err)
	}
	ohmic, err := connection.NewOhmic("ohmic")
	if err != nil {
		t.Fatalf("NewOhmic (ohmic) error: %v", err)
	}
	return right, ohmic
}

func TestLeftReservoirWithImplantedOhmic_LifecycleAndAccessors(t *testing.T) {
	right, ohmic := makeTestConnections(t)
	lr, err := New("LR1", right, ohmic)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer lr.Close()

	t.Run("Name", func(t *testing.T) {
		name, err := lr.Name()
		if err != nil {
			t.Fatalf("Name() error: %v", err)
		}
		if name != "LR1" {
			t.Errorf("Name() = %v, want LR1", name)
		}
	})

	t.Run("Type", func(t *testing.T) {
		typ, err := lr.Type()
		if err != nil {
			t.Fatalf("Type() error: %v", err)
		}
		if typ == "" {
			t.Errorf("Type() returned empty string")
		}
	})

	t.Run("Ohmic", func(t *testing.T) {
		ohmicConn, err := lr.Ohmic()
		if err != nil {
			t.Fatalf("Ohmic() error: %v", err)
		}
		if ohmicConn == nil {
			t.Errorf("Ohmic() returned nil")
		}
	})

	t.Run("RightNeighbor", func(t *testing.T) {
		rightConn, err := lr.RightNeighbor()
		if err != nil {
			t.Fatalf("RightNeighbor() error: %v", err)
		}
		if rightConn == nil {
			t.Errorf("RightNeighbor() returned nil")
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := lr.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		lr2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer lr2.Close()
		name2, err := lr2.Name()
		if err != nil {
			t.Fatalf("FromJSON Name error: %v", err)
		}
		if name2 != "LR1" {
			t.Errorf("FromJSON/ToJSON roundtrip failed: got %v, want LR1", name2)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := lr.Equal(lr2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := lr.NotEqual(lr2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestLeftReservoirWithImplantedOhmic_ClosedErrors(t *testing.T) {
	right, ohmic := makeTestConnections(t)
	lr, err := New("LR2", right, ohmic)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	lr.Close()
	if _, err := lr.Name(); err == nil {
		t.Error("Name() on closed: expected error")
	}
	if _, err := lr.Type(); err == nil {
		t.Error("Type() on closed: expected error")
	}
	if _, err := lr.Ohmic(); err == nil {
		t.Error("Ohmic() on closed: expected error")
	}
	if _, err := lr.RightNeighbor(); err == nil {
		t.Error("RightNeighbor() on closed: expected error")
	}
	if _, err := lr.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := lr.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
	other, err := New("LR3", right, ohmic)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer other.Close()
	if _, err := lr.Equal(other); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := lr.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
}

func TestLeftReservoirWithImplantedOhmic_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestLeftReservoirWithImplantedOhmic_FromCAPI_Valid(t *testing.T) {
	right, ohmic := makeTestConnections(t)
	lr, err := New("LR4", right, ohmic)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer lr.Close()
	capi, err := lr.CAPIHandle()
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
