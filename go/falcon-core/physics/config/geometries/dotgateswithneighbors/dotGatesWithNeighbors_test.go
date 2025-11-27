package dotgateswithneighbors

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/dotgatewithneighbors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
)

func TestDotGatesWithNeighbors_NewEmptyAndClose(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	if h == nil {
		t.Fatal("NewEmpty returned nil")
	}
}

func TestDotGatesWithNeighbors_NewAndSize(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	if sz, err := h.Size(); err != nil {
		t.Errorf("Size failed: %v", err)
	} else if sz != 0 {
		t.Errorf("Expected size 0, got %d", sz)
	}
}

func TestDotGatesWithNeighbors_PushBackAndEraseAt(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	left, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf(`Failed to create barrier gate: %v`, err)
	}
	right, err := connection.NewBarrierGate("B2")
	if err != nil {
		t.Fatalf(`Failed to create barrier gate: %v`, err)
	}
	gate, err := dotgatewithneighbors.NewPlungerGateWithNeighbors("P1", left, right)
	if err != nil {
		t.Fatalf(`Failed to create plunger gate with neighbors: %v`, err)
	}
	if err := h.PushBack(gate); err != nil {
		t.Errorf("PushBack failed: %v", err)
	}
	if sz, _ := h.Size(); sz != 1 {
		t.Errorf("Expected size 1 after PushBack, got %d", sz)
	}
	if err := h.EraseAt(0); err != nil {
		t.Errorf("EraseAt failed: %v", err)
	}
	if sz, _ := h.Size(); sz != 0 {
		t.Errorf("Expected size 0 after EraseAt, got %d", sz)
	}
}

func TestDotGatesWithNeighbors_ClearAndEmpty(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	h.PushBack(nil)
	if err := h.Clear(); err != nil {
		t.Errorf("Clear failed: %v", err)
	}
	if empty, err := h.Empty(); err != nil || !empty {
		t.Errorf("Expected Empty true after Clear, got %v, err: %v", empty, err)
	}
}

func TestDotGatesWithNeighbors_At(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	left, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf(`Failed to create barrier gate: %v`, err)
	}
	right, err := connection.NewBarrierGate("B2")
	if err != nil {
		t.Fatalf(`Failed to create barrier gate: %v`, err)
	}
	gate, err := dotgatewithneighbors.NewPlungerGateWithNeighbors("P1", left, right)
	if err != nil {
		t.Fatalf(`Failed to create plunger gate with neighbors: %v`, err)
	}
	if err := h.PushBack(gate); err != nil {
		t.Errorf("PushBack failed: %v", err)
	}
	if _, err := h.At(0); err != nil {
		t.Errorf("At failed: %v", err)
	}
}

func TestDotGatesWithNeighbors_Items(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	if _, err := h.Items(); err != nil {
		t.Errorf("Items failed: %v", err)
	}
}

func TestDotGatesWithNeighbors_ContainsAndIndex(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	left, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf(`Failed to create barrier gate: %v`, err)
	}
	right, err := connection.NewBarrierGate("B2")
	if err != nil {
		t.Fatalf(`Failed to create barrier gate: %v`, err)
	}
	gate, err := dotgatewithneighbors.NewPlungerGateWithNeighbors("P1", left, right)
	if err != nil {
		t.Fatalf(`Failed to create plunger gate with neighbors: %v`, err)
	}
	if err := h.PushBack(gate); err != nil {
		t.Errorf("PushBack failed: %v", err)
	}
	if ok, err := h.Contains(gate); err != nil || !ok {
		t.Errorf("Contains failed: %v", err)
	}
	if idx, err := h.Index(gate); err != nil || idx != 0 {
		t.Errorf("Index failed: %v", err)
	}
}

func TestDotGatesWithNeighbors_IsPlungerAndBarrier(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	if _, err := h.IsPlungerGates(); err != nil {
		t.Errorf("IsPlungerGates failed: %v", err)
	}
	if _, err := h.IsBarrierGates(); err != nil {
		t.Errorf("IsBarrierGates failed: %v", err)
	}
}

func TestDotGatesWithNeighbors_Intersection(t *testing.T) {
	h1, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h1.Close()
	h2, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h2.Close()
	res, err := h1.Intersection(h2)
	if err != nil {
		t.Errorf("Intersection failed: %v", err)
	}
	defer res.Close()
}

func TestDotGatesWithNeighbors_EqualAndNotEqual(t *testing.T) {
	h1, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h1.Close()
	h2, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h2.Close()
	ok, err := h1.Equal(h2)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	_ = ok
	ok, err = h1.NotEqual(h2)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	_ = ok
}

func TestDotGatesWithNeighbors_ToJSONAndFromJSON(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	defer h.Close()
	js, err := h.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON failed: %v", err)
	}
	h2, err := FromJSON(js)
	if err != nil {
		t.Fatalf("FromJSON failed: %v", err)
	}
	defer h2.Close()
}

func TestDotGatesWithNeighbors_ErrorBranches(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf(`Failed to create empty dot gates with neighbors: %v`, err)
	}
	h.Close()
	_, err = h.Size()
	if err == nil {
		t.Error("Expected error on Size after Close")
	}
	_, err = h.At(0)
	if err == nil {
		t.Error("Expected error on At after Close")
	}
	_, err = h.Items()
	if err == nil {
		t.Error("Expected error on Items after Close")
	}
	_, err = h.Contains(nil)
	if err == nil {
		t.Error("Expected error on Contains after Close")
	}
	_, err = h.Index(nil)
	if err == nil {
		t.Error("Expected error on Index after Close")
	}
	_, err = h.IsPlungerGates()
	if err == nil {
		t.Error("Expected error on IsPlungerGates after Close")
	}
	_, err = h.IsBarrierGates()
	if err == nil {
		t.Error("Expected error on IsBarrierGates after Close")
	}
	_, err = h.Equal(nil)
	if err == nil {
		t.Error("Expected error on Equal with nil")
	}
	_, err = h.NotEqual(nil)
	if err == nil {
		t.Error("Expected error on NotEqual with nil")
	}
}
