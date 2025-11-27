package porttransforms

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/analyticfunction"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestPortTransforms(t *testing.T) []*porttransform.Handle {
	names := []string{"A", "B", "C"}
	var out []*porttransform.Handle
	for _, n := range names {
		conn, _ := connection.NewBarrierGate(n)
		v, _ := symbolunit.NewVolt()
		port, _ := instrumentport.NewKnob(n, conn, instrumenttypes.VoltageSource(), v, "")
		af, _ := analyticfunction.NewIdentity()
		p, err := porttransform.New(port, af)
		if err != nil {
			t.Fatalf("porttransform.New(%q) error: %v", n, err)
		}
		out = append(out, p)
	}
	return out
}

func withPortTransforms(t *testing.T, fn func(t *testing.T, pt *Handle, items []*porttransform.Handle)) {
	items := makeTestPortTransforms(t)
	pt, err := New(items)
	if err != nil {
		t.Fatalf("NewRaw error: %v", err)
	}
	defer pt.Close()
	fn(t, pt, items)
}

func TestPortTransforms_SizeAndItems(t *testing.T) {
	withPortTransforms(t, func(t *testing.T, pt *Handle, items []*porttransform.Handle) {
		sz, err := pt.Size()
		if err != nil {
			t.Fatalf("Size() error: %v", err)
		}
		if sz != uint32(len(items)) {
			t.Errorf("Size() = %v, want %v", sz, len(items))
		}
		list, err := pt.Items()
		if err != nil {
			t.Fatalf("Items() error: %v", err)
		}
		got, err := list.Items()
		if err != nil {
			t.Fatalf("List.Items() error: %v", err)
		}
		if len(got) != len(items) {
			t.Errorf("Items() length = %v, want %v", len(got), len(items))
		}
	})
}

func TestPortTransforms_At(t *testing.T) {
	withPortTransforms(t, func(t *testing.T, pt *Handle, items []*porttransform.Handle) {
		for i, want := range items {
			got, err := pt.At(uint32(i))
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

func TestPortTransforms_ContainsAndIndex(t *testing.T) {
	withPortTransforms(t, func(t *testing.T, pt *Handle, items []*porttransform.Handle) {
		for i, v := range items {
			ok, err := pt.Contains(v)
			if err != nil {
				t.Fatalf("Contains(%d) error: %v", i, err)
			}
			if !ok {
				t.Errorf("Contains(%d) = false, want true", i)
			}
			idx, err := pt.Index(v)
			if err != nil {
				t.Fatalf("Index(%d) error: %v", i, err)
			}
			if idx != uint32(i) {
				t.Errorf("Index(%d) = %v, want %v", i, idx, i)
			}
		}
	})
}

func TestPortTransforms_PushBack(t *testing.T) {
	withPortTransforms(t, func(t *testing.T, pt *Handle, items []*porttransform.Handle) {
		n := "D"
		conn, _ := connection.NewBarrierGate(n)
		v, _ := symbolunit.NewVolt()
		port, _ := instrumentport.NewKnob(n, conn, instrumenttypes.VoltageSource(), v, "")
		af, _ := analyticfunction.NewIdentity()
		newPT, err := porttransform.New(port, af)
		if err != nil {
			t.Fatalf("porttransform.New(D) error: %v", err)
		}
		defer newPT.Close()
		if err := pt.PushBack(newPT); err != nil {
			t.Fatalf("PushBack error: %v", err)
		}
		sz, _ := pt.Size()
		if sz != uint32(len(items)+1) {
			t.Errorf("After PushBack, Size() = %v, want %v", sz, len(items)+1)
		}
	})
}

func TestPortTransforms_EraseAtAndClear(t *testing.T) {
	items := makeTestPortTransforms(t)
	pt, err := New(items)
	if err != nil {
		t.Fatalf("NewRaw error: %v", err)
	}
	defer pt.Close()
	if err := pt.EraseAt(1); err != nil {
		t.Fatalf("EraseAt error: %v", err)
	}
	sz, _ := pt.Size()
	if sz != uint32(len(items)-1) {
		t.Errorf("After EraseAt, Size() = %v, want %v", sz, len(items)-1)
	}
	if err := pt.Clear(); err != nil {
		t.Fatalf("Clear error: %v", err)
	}
	empty, _ := pt.Empty()
	if !empty {
		t.Errorf("After Clear, Empty() = false, want true")
	}
}

func TestPortTransforms_Intersection(t *testing.T) {
	withPortTransforms(t, func(t *testing.T, pt *Handle, items []*porttransform.Handle) {
		pt2, err := New(items)
		if err != nil {
			t.Fatalf("NewRaw error: %v", err)
		}
		defer pt2.Close()
		inter, err := pt.Intersection(pt2)
		if err != nil {
			t.Fatalf("Intersection error: %v", err)
		}
		defer inter.Close()
		list, err := inter.Items()
		if err != nil {
			t.Fatalf("Intersection Items error: %v", err)
		}
		got, err := list.Items()
		if err != nil {
			t.Fatalf("List.Items() error: %v", err)
		}
		if len(got) != len(items) {
			t.Errorf("Intersection Items = %v, want %v", len(got), len(items))
		}
	})
}

func TestPortTransforms_EqualAndNotEqual(t *testing.T) {
	withPortTransforms(t, func(t *testing.T, pt *Handle, items []*porttransform.Handle) {
		pt2, err := New(items)
		if err != nil {
			t.Fatalf("NewRaw error: %v", err)
		}
		defer pt2.Close()
		eq, err := pt.Equal(pt2)
		if err != nil || !eq {
			t.Errorf("Equal = %v, want true, err: %v", eq, err)
		}
		neq, err := pt.NotEqual(pt2)
		if err != nil || neq {
			t.Errorf("NotEqual = %v, want false, err: %v", neq, err)
		}
	})
}

func TestPortTransforms_ToJSONAndFromJSON(t *testing.T) {
	withPortTransforms(t, func(t *testing.T, pt *Handle, items []*porttransform.Handle) {
		jsonStr, err := pt.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		pt2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer pt2.Close()
		eq, err := pt.Equal(pt2)
		if err != nil || !eq {
			t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
		}
	})
}

func TestPortTransforms_ClosedErrors(t *testing.T) {
	items := makeTestPortTransforms(t)
	pt, err := New(items)
	if err != nil {
		t.Fatalf("NewRaw error: %v", err)
	}
	pt.Close()
	if _, err := pt.Size(); err == nil {
		t.Error("Size() on closed: expected error")
	}
	if _, err := pt.Items(); err == nil {
		t.Error("Items() on closed: expected error")
	}
	if _, err := pt.At(0); err == nil {
		t.Error("At() on closed: expected error")
	}
	if _, err := pt.Contains(items[0]); err == nil {
		t.Error("Contains() on closed: expected error")
	}
	if _, err := pt.Index(items[0]); err == nil {
		t.Error("Index() on closed: expected error")
	}
	if _, err := pt.Equal(pt); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := pt.NotEqual(pt); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
	if _, err := pt.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := pt.PushBack(items[0]); err == nil {
		t.Error("PushBack() on closed: expected error")
	}
	if err := pt.EraseAt(0); err == nil {
		t.Error("EraseAt() on closed: expected error")
	}
	if err := pt.Clear(); err == nil {
		t.Error("Clear() on closed: expected error")
	}
	if err := pt.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestPortTransforms_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestPortTransforms_FromCAPI_Valid(t *testing.T) {
	withPortTransforms(t, func(t *testing.T, pt *Handle, _ []*porttransform.Handle) {
		capi := pt.CAPIHandle()
		h, err := FromCAPI(capi)
		if err != nil {
			t.Errorf("FromCAPI valid: unexpected error: %v", err)
		}
		if h == nil {
			t.Fatal("FromCAPI valid: got nil")
		}
	})
}
