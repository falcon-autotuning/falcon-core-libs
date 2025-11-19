package gaterelations

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connections"
)

func mustConnection(id string) *connection.Handle {
	h, err := connection.NewBarrierGate(id)
	if err != nil {
		panic(err)
	}
	return h
}

func mustConnections(ids ...string) *connections.Handle {
	handles := make([]*connection.Handle, len(ids))
	for i, id := range ids {
		h, err := connection.NewBarrierGate(id)
		if err != nil {
			panic(err)
		}
		handles[i] = h
	}
	h, err := connections.New(handles)
	if err != nil {
		panic(err)
	}
	return h
}

func TestGateRelations_FullCoverage(t *testing.T) {
	// NewEmpty
	gr, err := NewEmpty()
	if err != nil {
		t.Fatalf("NewEmpty failed: %v", err)
	}
	defer gr.Close()

	// Size/Empty
	sz, err := gr.Size()
	if err != nil {
		t.Errorf("Size failed: %v", err)
	}
	if sz != 0 {
		t.Errorf("Expected size 0, got %d", sz)
	}
	empty, err := gr.Empty()
	if err != nil {
		t.Errorf("Empty failed: %v", err)
	}
	if !empty {
		t.Errorf("Expected empty true")
	}

	// InsertOrAssign, Insert, Contains, At, Erase
	key := mustConnection("k1")
	defer key.Close()
	val := mustConnections("v1", "v2")
	defer val.Close()
	if err := gr.InsertOrAssign(key, val); err != nil {
		t.Errorf("InsertOrAssign failed: %v", err)
	}
	if err := gr.Insert(key, val); err != nil {
		t.Errorf("Insert failed: %v", err)
	}
	found, err := gr.Contains(key)
	if err != nil {
		t.Errorf("Contains failed: %v", err)
	}
	if !found {
		t.Errorf("Expected Contains true")
	}
	gotVal, err := gr.At(key)
	if err != nil {
		t.Errorf("At failed: %v", err)
	}
	if gotVal == nil {
		t.Errorf("At returned nil")
	} else {
		gotVal.Close()
	}
	if err := gr.Erase(key); err != nil {
		t.Errorf("Erase failed: %v", err)
	}

	// Clear
	if err := gr.Clear(); err != nil {
		t.Errorf("Clear failed: %v", err)
	}

	// Keys, Values, Items
	_ = gr.InsertOrAssign(key, val)
	keys, err := gr.Keys()
	if err != nil {
		t.Errorf("Keys failed: %v", err)
	}
	if keys != nil {
		keys.Close()
	}
	values, err := gr.Values()
	if err != nil {
		t.Errorf("Values failed: %v", err)
	}
	if values != nil {
		values.Close()
	}
	items, err := gr.Items()
	if err != nil {
		t.Errorf("Items failed: %v", err)
	}
	if items != nil {
		items.Close()
	}

	// ToJSON/FromJSON
	jsonStr, err := gr.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	gr2, err := FromJSON(jsonStr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	defer gr2.Close()

	// Equal/NotEqual
	eq, err := gr.Equal(gr2)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	if !eq {
		t.Errorf("Expected Equal true")
	}
	neq, err := gr.NotEqual(gr2)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	if neq {
		t.Errorf("Expected NotEqual false")
	}

	// Equal/NotEqual with nil/closed
	_, err = gr.Equal(nil)
	if err == nil {
		t.Errorf("Equal with nil should error")
	}
	gr2.Close()
	_, err = gr.Equal(gr2)
	if err == nil {
		t.Errorf("Equal with closed should error")
	}
	_, err = gr.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual with nil should error")
	}
	_, err = gr.NotEqual(gr2)
	if err == nil {
		t.Errorf("NotEqual with closed should error")
	}

	// CAPIHandle (open/closed)
	ptr, err := gr.CAPIHandle()
	if err != nil || ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}
	gr.Close()
	_, err = gr.CAPIHandle()
	if err == nil {
		t.Errorf("CAPIHandle on closed should error")
	}
	// Close twice
	err = gr.Close()
	if err == nil {
		t.Errorf("Second Close should error")
	}
}
