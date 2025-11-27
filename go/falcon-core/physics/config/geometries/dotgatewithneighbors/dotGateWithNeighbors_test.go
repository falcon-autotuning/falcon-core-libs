package dotgatewithneighbors

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
)

func makePlungerNeighbors(t *testing.T) (*connection.Handle, *connection.Handle) {
	left, err := connection.NewPlungerGate("L")
	if err != nil {
		t.Fatalf("NewPlungerGate left error: %v", err)
	}
	right, err := connection.NewPlungerGate("R")
	if err != nil {
		t.Fatalf("NewPlungerGate right error: %v", err)
	}
	return left, right
}

func makeBarrierNeighbors(t *testing.T) (*connection.Handle, *connection.Handle) {
	left, err := connection.NewBarrierGate("L")
	if err != nil {
		t.Fatalf("NewBarrierGate left error: %v", err)
	}
	right, err := connection.NewBarrierGate("R")
	if err != nil {
		t.Fatalf("NewBarrierGate right error: %v", err)
	}
	return left, right
}

func TestDotGateWithNeighbors_LifecycleAndAccessors(t *testing.T) {
	left, right := makeBarrierNeighbors(t)
	gate, err := NewPlungerGateWithNeighbors("PG", left, right)
	if err != nil {
		t.Fatalf("NewPlungerGateWithNeighbors error: %v", err)
	}
	defer gate.Close()

	t.Run("Name", func(t *testing.T) {
		name, err := gate.Name()
		if err != nil {
			t.Fatalf("Name() error: %v", err)
		}
		if name != "PG" {
			t.Errorf("Name() = %v, want PG", name)
		}
	})

	t.Run("Type", func(t *testing.T) {
		typ, err := gate.Type()
		if err != nil {
			t.Fatalf("Type() error: %v", err)
		}
		if typ == "" {
			t.Errorf("Type() returned empty string")
		}
	})

	t.Run("LeftNeighbor", func(t *testing.T) {
		ln, err := gate.LeftNeighbor()
		if err != nil {
			t.Fatalf("LeftNeighbor() error: %v", err)
		}
		if ln == nil {
			t.Fatalf("LeftNeighbor() returned nil")
		}
	})

	t.Run("RightNeighbor", func(t *testing.T) {
		rn, err := gate.RightNeighbor()
		if err != nil {
			t.Fatalf("RightNeighbor() error: %v", err)
		}
		if rn == nil {
			t.Fatalf("RightNeighbor() returned nil")
		}
	})

	t.Run("IsPlungerGate", func(t *testing.T) {
		isPlunger, err := gate.IsPlungerGate()
		if err != nil {
			t.Fatalf("IsPlungerGate() error: %v", err)
		}
		if !isPlunger {
			t.Errorf("IsPlungerGate() = false, want true")
		}
	})

	t.Run("IsBarrierGate", func(t *testing.T) {
		isBarrier, err := gate.IsBarrierGate()
		if err != nil {
			t.Fatalf("IsBarrierGate() error: %v", err)
		}
		if isBarrier {
			t.Errorf("IsBarrierGate() = true, want false")
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := gate.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		gate2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer gate2.Close()
		name2, err := gate2.Name()
		if err != nil {
			t.Fatalf("FromJSON Name error: %v", err)
		}
		if name2 != "PG" {
			t.Errorf("FromJSON/ToJSON roundtrip failed: got %v, want PG", name2)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := gate.Equal(gate2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := gate.NotEqual(gate2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestDotGateWithNeighbors_BarrierGate(t *testing.T) {
	left, right := makePlungerNeighbors(t)
	gate, err := NewBarrierGateWithNeighbors("BG", left, right)
	if err != nil {
		t.Fatalf("NewBarrierGateWithNeighbors error: %v", err)
	}
	defer gate.Close()
	isBarrier, err := gate.IsBarrierGate()
	if err != nil {
		t.Fatalf("IsBarrierGate() error: %v", err)
	}
	if !isBarrier {
		t.Errorf("IsBarrierGate() = false, want true")
	}
	isPlunger, err := gate.IsPlungerGate()
	if err != nil {
		t.Fatalf("IsPlungerGate() error: %v", err)
	}
	if isPlunger {
		t.Errorf("IsPlungerGate() = true, want false")
	}
}

func TestDotGateWithNeighbors_ClosedErrors(t *testing.T) {
	left, right := makeBarrierNeighbors(t)
	gate, err := NewPlungerGateWithNeighbors("PG", left, right)
	if err != nil {
		t.Fatalf("NewPlungerGateWithNeighbors error: %v", err)
	}
	gate.Close()
	if _, err := gate.Name(); err == nil {
		t.Error("Name() on closed gate: expected error")
	}
	if _, err := gate.Type(); err == nil {
		t.Error("Type() on closed gate: expected error")
	}
	if _, err := gate.LeftNeighbor(); err == nil {
		t.Error("LeftNeighbor() on closed gate: expected error")
	}
	if _, err := gate.RightNeighbor(); err == nil {
		t.Error("RightNeighbor() on closed gate: expected error")
	}
	if _, err := gate.IsBarrierGate(); err == nil {
		t.Error("IsBarrierGate() on closed gate: expected error")
	}
	if _, err := gate.IsPlungerGate(); err == nil {
		t.Error("IsPlungerGate() on closed gate: expected error")
	}
	if _, err := gate.ToJSON(); err == nil {
		t.Error("ToJSON() on closed gate: expected error")
	}
	if err := gate.Close(); err == nil {
		t.Error("Close() on closed gate: expected error")
	}
	other, err := NewPlungerGateWithNeighbors("PG2", left, right)
	if err != nil {
		t.Fatalf("NewPlungerGateWithNeighbors error: %v", err)
	}
	defer other.Close()
	if _, err := gate.Equal(other); err == nil {
		t.Error("Equal() on closed gate: expected error")
	}
	if _, err := gate.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed gate: expected error")
	}
}

func TestDotGateWithNeighbors_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestDotGateWithNeighbors_FromCAPI_Valid(t *testing.T) {
	left, right := makeBarrierNeighbors(t)
	gate, err := NewPlungerGateWithNeighbors("PG", left, right)
	if err != nil {
		t.Fatalf("NewPlungerGateWithNeighbors error: %v", err)
	}
	defer gate.Close()
	capi := gate.CAPIHandle()
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
