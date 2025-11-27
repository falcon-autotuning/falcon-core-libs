package devicevoltagestates

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestDeviceVoltageStates(t *testing.T) []*devicevoltagestate.Handle {
	names := []string{"A", "B", "C"}
	var out []*devicevoltagestate.Handle
	for i, n := range names {
		conn, err := connection.NewBarrierGate(n)
		if err != nil {
			t.Fatalf("NewBarrierGate(%q) error: %v", n, err)
		}
		v, err := symbolunit.NewVolt()
		if err != nil {
			t.Fatalf("Could not create a volt: %v", err)
		}
		state, err := devicevoltagestate.New(conn, float64(i), v)
		if err != nil {
			t.Fatalf("devicevoltagestate.New(%q) error: %v", n, err)
		}
		out = append(out, state)
	}
	return out
}

func withDeviceVoltageStates(t *testing.T, fn func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle)) {
	states := makeTestDeviceVoltageStates(t)
	h, err := New(states)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	fn(t, h, states)
}

func TestDeviceVoltageStates_SizeAndItems(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle) {
		sz, err := h.Size()
		if err != nil {
			t.Fatalf("Size() error: %v", err)
		}
		if sz != uint32(len(states)) {
			t.Errorf("Size() = %v, want %v", sz, len(states))
		}
		items, err := h.Items()
		if err != nil {
			t.Fatalf("Items() error: %v", err)
		}
		if size, _ := items.Size(); size != uint32(len(states)) {
			t.Errorf("Items() length = %v, want %v", size, len(states))
		}
	})
}

func TestDeviceVoltageStates_At(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle) {
		for i, want := range states {
			got, err := h.At(uint32(i))
			if err != nil {
				t.Fatalf("At(%d) error: %v", i, err)
			}
			eq, err := got.Equal(want)
			if err != nil || !eq {
				t.Errorf("At(%d) = %v, want %v", i, got, want)
			}
		}
	})
}

func TestDeviceVoltageStates_ContainsAndIndex(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle) {
		for i, v := range states {
			ok, err := h.Contains(v)
			if err != nil {
				t.Fatalf("Contains(%d) error: %v", i, err)
			}
			if !ok {
				t.Errorf("Contains(%d) = false, want true", i)
			}
			idx, err := h.Index(v)
			if err != nil {
				t.Fatalf("Index(%d) error: %v", i, err)
			}
			if idx != uint32(i) {
				t.Errorf("Index(%d) = %v, want %v", i, idx, i)
			}
		}
	})
}

func TestDeviceVoltageStates_PushBack(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle) {
		conn, err := connection.NewBarrierGate("D")
		if err != nil {
			t.Fatalf("NewBarrierGate(D) error: %v", err)
		}
		v, err := symbolunit.NewVolt()
		if err != nil {
			t.Fatalf("Could not create a volt: %v", err)
		}
		newState, err := devicevoltagestate.New(conn, 42.0, v)
		if err != nil {
			t.Fatalf("devicevoltagestate.New(D) error: %v", err)
		}
		if err := h.PushBack(newState); err != nil {
			t.Fatalf("PushBack error: %v", err)
		}
		sz, _ := h.Size()
		if sz != uint32(len(states)+1) {
			t.Errorf("After PushBack, Size() = %v, want %v", sz, len(states)+1)
		}
	})
}

func TestDeviceVoltageStates_EraseAtAndClear(t *testing.T) {
	states := makeTestDeviceVoltageStates(t)
	h, err := New(states)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	if err := h.EraseAt(1); err != nil {
		t.Fatalf("EraseAt error: %v", err)
	}
	sz, _ := h.Size()
	if sz != uint32(len(states)-1) {
		t.Errorf("After EraseAt, Size() = %v, want %v", sz, len(states)-1)
	}
	if err := h.Clear(); err != nil {
		t.Fatalf("Clear error: %v", err)
	}
	empty, _ := h.Empty()
	if !empty {
		t.Errorf("After Clear, Empty() = false, want true")
	}
}

func TestDeviceVoltageStates_Intersection(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle) {
		h2, err := New(states)
		if err != nil {
			t.Fatalf("New error: %v", err)
		}
		defer h2.Close()
		inter, err := h.Intersection(h2)
		if err != nil {
			t.Fatalf("Intersection error: %v", err)
		}
		defer inter.Close()
		items, err := inter.Items()
		if err != nil {
			t.Fatalf("Intersection Items error: %v", err)
		}
		if size, _ := items.Size(); size != uint32(len(states)) {
			t.Errorf("Intersection Items = %v, want %v", size, len(states))
		}
	})
}

func TestDeviceVoltageStates_EqualAndNotEqual(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle) {
		h2, err := New(states)
		if err != nil {
			t.Fatalf("New error: %v", err)
		}
		defer h2.Close()
		eq, err := h.Equal(h2)
		if err != nil || !eq {
			t.Errorf("Equal = %v, want true, err: %v", eq, err)
		}
		neq, err := h.NotEqual(h2)
		if err != nil || neq {
			t.Errorf("NotEqual = %v, want false, err: %v", neq, err)
		}
	})
}

func TestDeviceVoltageStates_ToJSONAndFromJSON(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle) {
		jsonStr, err := h.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		h2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer h2.Close()
		eq, err := h.Equal(h2)
		if err != nil || !eq {
			t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
		}
	})
}

func TestDeviceVoltageStates_ClosedErrors(t *testing.T) {
	states := makeTestDeviceVoltageStates(t)
	h, err := New(states)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	h.Close()
	if _, err := h.Size(); err == nil {
		t.Error("Size() on closed: expected error")
	}
	if _, err := h.Items(); err == nil {
		t.Error("Items() on closed: expected error")
	}
	if _, err := h.At(0); err == nil {
		t.Error("At() on closed: expected error")
	}
	if _, err := h.Contains(states[0]); err == nil {
		t.Error("Contains() on closed: expected error")
	}
	if _, err := h.Index(states[0]); err == nil {
		t.Error("Index() on closed: expected error")
	}
	if _, err := h.Equal(h); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := h.NotEqual(h); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
	if _, err := h.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := h.PushBack(states[0]); err == nil {
		t.Error("PushBack() on closed: expected error")
	}
	if err := h.EraseAt(0); err == nil {
		t.Error("EraseAt() on closed: expected error")
	}
	if err := h.Clear(); err == nil {
		t.Error("Clear() on closed: expected error")
	}
	if err := h.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestDeviceVoltageStates_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestDeviceVoltageStates_FromCAPI_Valid(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, _ []*devicevoltagestate.Handle) {
		capi := h.CAPIHandle()
		h2, err := FromCAPI(capi)
		if err != nil {
			t.Errorf("FromCAPI valid: unexpected error: %v", err)
		}
		if h2 == nil {
			t.Fatal("FromCAPI valid: got nil")
		}
	})
}

func TestDeviceVoltageStates_StatesAndAddState(t *testing.T) {
	h, err := NewEmpty()
	if err != nil {
		t.Fatalf("NewEmpty error: %v", err)
	}
	defer h.Close()
	conn, err := connection.NewBarrierGate("X")
	if err != nil {
		t.Fatalf("NewBarrierGate(X) error: %v", err)
	}
	v, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("Could not create a volt: %v", err)
	}
	state, err := devicevoltagestate.New(conn, 123.0, v)
	if err != nil {
		t.Fatalf("devicevoltagestate.New(X) error: %v", err)
	}
	if err := h.AddState(state); err != nil {
		t.Fatalf("AddState error: %v", err)
	}
	states, err := h.States()
	if err != nil {
		t.Fatalf("States() error: %v", err)
	}
	if size, _ := states.Size(); size != 1 {
		t.Errorf("States() length = %v, want 1", size)
	}
}

func TestDeviceVoltageStates_FindState(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, states []*devicevoltagestate.Handle) {
		conn, err := connection.NewBarrierGate("A")
		if err != nil {
			t.Fatalf("NewBarrierGate(A) error: %v", err)
		}
		found, err := h.FindState(conn)
		if err != nil {
			t.Fatalf("FindState error: %v", err)
		}
		if found == nil {
			t.Error("FindState: got nil, want non-nil")
		}
	})
}

func TestDeviceVoltageStates_ToPoint(t *testing.T) {
	withDeviceVoltageStates(t, func(t *testing.T, h *Handle, _ []*devicevoltagestate.Handle) {
		pt, err := h.ToPoint()
		if err != nil {
			t.Fatalf("ToPoint error: %v", err)
		}
		if pt == nil {
			t.Error("ToPoint: got nil, want non-nil")
		}
	})
}
