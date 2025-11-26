package impedances

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/impedance"
)

func makeTestImpedances(t *testing.T) []*impedance.Handle {
	var out []*impedance.Handle
	for i, name := range []string{"A", "B", "C"} {
		conn, err := connection.NewBarrierGate(name)
		if err != nil {
			t.Fatalf("connection.NewBarrierGate(%q) error: %v", name, err)
		}
		imp, err := impedance.New(conn, float64(i+1), float64(i+10))
		if err != nil {
			t.Fatalf("impedance.New(%q) error: %v", name, err)
		}
		out = append(out, imp)
	}
	return out
}

func withImpedances(t *testing.T, fn func(t *testing.T, h *Handle, imps []*impedance.Handle)) {
	imps := makeTestImpedances(t)
	h, err := New(imps)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	fn(t, h, imps)
}

func TestImpedances_SizeAndItems(t *testing.T) {
	withImpedances(t, func(t *testing.T, h *Handle, imps []*impedance.Handle) {
		sz, err := h.Size()
		if err != nil {
			t.Fatalf("Size() error: %v", err)
		}
		if sz != uint32(len(imps)) {
			t.Errorf("Size() = %v, want %v", sz, len(imps))
		}
		items, err := h.Items()
		if err != nil {
			t.Fatalf("Items() error: %v", err)
		}
		if size, _ := items.Size(); size != len(imps) {
			t.Errorf("Items() length = %v, want %v", size, len(imps))
		}
	})
}

func TestImpedances_At(t *testing.T) {
	withImpedances(t, func(t *testing.T, h *Handle, imps []*impedance.Handle) {
		for i, want := range imps {
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

func TestImpedances_ContainsAndIndex(t *testing.T) {
	withImpedances(t, func(t *testing.T, h *Handle, imps []*impedance.Handle) {
		for i, v := range imps {
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

func TestImpedances_PushBack(t *testing.T) {
	withImpedances(t, func(t *testing.T, h *Handle, imps []*impedance.Handle) {
		conn, err := connection.NewBarrierGate("D")
		if err != nil {
			t.Fatalf("connection.NewBarrierGate(D) error: %v", err)
		}
		newImp, err := impedance.New(conn, 99, 88)
		if err != nil {
			t.Fatalf("impedance.New error: %v", err)
		}
		if err := h.PushBack(newImp); err != nil {
			t.Fatalf("PushBack error: %v", err)
		}
		sz, _ := h.Size()
		if sz != uint32(len(imps)+1) {
			t.Errorf("After PushBack, Size() = %v, want %v", sz, len(imps)+1)
		}
	})
}

func TestImpedances_EraseAtAndClear(t *testing.T) {
	imps := makeTestImpedances(t)
	h, err := New(imps)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	if err := h.EraseAt(1); err != nil {
		t.Fatalf("EraseAt error: %v", err)
	}
	sz, _ := h.Size()
	if sz != uint32(len(imps)-1) {
		t.Errorf("After EraseAt, Size() = %v, want %v", sz, len(imps)-1)
	}
	if err := h.Clear(); err != nil {
		t.Fatalf("Clear error: %v", err)
	}
	empty, _ := h.Empty()
	if !empty {
		t.Errorf("After Clear, Empty() = false, want true")
	}
}

func TestImpedances_Intersection(t *testing.T) {
	withImpedances(t, func(t *testing.T, h *Handle, imps []*impedance.Handle) {
		h2, err := New(imps)
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
		if size, _ := items.Size(); size != len(imps) {
			t.Errorf("Intersection Items = %v, want %v", size, len(imps))
		}
	})
}

func TestImpedances_EqualAndNotEqual(t *testing.T) {
	withImpedances(t, func(t *testing.T, h *Handle, imps []*impedance.Handle) {
		h2, err := New(imps)
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

func TestImpedances_ToJSONAndFromJSON(t *testing.T) {
	withImpedances(t, func(t *testing.T, h *Handle, imps []*impedance.Handle) {
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

func TestImpedances_ClosedErrors(t *testing.T) {
	imps := makeTestImpedances(t)
	h, err := New(imps)
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
	if _, err := h.Contains(imps[0]); err == nil {
		t.Error("Contains() on closed: expected error")
	}
	if _, err := h.Index(imps[0]); err == nil {
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
	if err := h.PushBack(imps[0]); err == nil {
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

func TestImpedances_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestImpedances_FromCAPI_Valid(t *testing.T) {
	withImpedances(t, func(t *testing.T, h *Handle, _ []*impedance.Handle) {
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
