package connections

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
)

func makeTestConnections(t *testing.T) []*connection.Handle {
	names := []string{"A", "B", "C"}
	var out []*connection.Handle
	for _, n := range names {
		c, err := connection.NewBarrierGate(n)
		if err != nil {
			t.Fatalf("NewBarrierGate(%q) error: %v", n, err)
		}
		out = append(out, c)
	}
	return out
}

func withConnections(t *testing.T, fn func(t *testing.T, c *Handle, conns []*connection.Handle)) {
	conns := makeTestConnections(t)
	c, err := New(conns)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer c.Close()
	fn(t, c, conns)
}

func TestConnections_SizeAndItems(t *testing.T) {
	withConnections(t, func(t *testing.T, c *Handle, conns []*connection.Handle) {
		sz, err := c.Size()
		if err != nil {
			t.Fatalf("Size() error: %v", err)
		}
		if sz != uint32(len(conns)) {
			t.Errorf("Size() = %v, want %v", sz, len(conns))
		}
		items, err := c.Items()
		if err != nil {
			t.Fatalf("Items() error: %v", err)
		}
		if size, _ := items.Size(); size != uint32(len(conns)) {
			t.Errorf("Items() length = %v, want %v", size, len(conns))
		}
	})
}

func TestConnections_At(t *testing.T) {
	withConnections(t, func(t *testing.T, c *Handle, conns []*connection.Handle) {
		for i, want := range conns {
			got, err := c.At(uint32(i))
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

func TestConnections_ContainsAndIndex(t *testing.T) {
	withConnections(t, func(t *testing.T, c *Handle, conns []*connection.Handle) {
		for i, v := range conns {
			j := uint32(i)
			ok, err := c.Contains(v)
			if err != nil {
				t.Fatalf("Contains(%d) error: %v", i, err)
			}
			if !ok {
				t.Errorf("Contains(%d) = false, want true", i)
			}
			idx, err := c.Index(v)
			if err != nil {
				t.Fatalf("Index(%d) error: %v", i, err)
			}
			if idx != j {
				t.Errorf("Index(%d) = %v, want %v", i, idx, i)
			}
		}
	})
}

func TestConnections_PushBack(t *testing.T) {
	withConnections(t, func(t *testing.T, c *Handle, conns []*connection.Handle) {
		newConn, err := connection.NewBarrierGate("D")
		if err != nil {
			t.Fatalf("NewBarrierGate(D) error: %v", err)
		}
		if err := c.PushBack(newConn); err != nil {
			t.Fatalf("PushBack error: %v", err)
		}
		sz, _ := c.Size()
		if sz != uint32(len(conns)+1) {
			t.Errorf("After PushBack, Size() = %v, want %v", sz, len(conns)+1)
		}
	})
}

func TestConnections_EraseAtAndClear(t *testing.T) {
	conns := makeTestConnections(t)
	c2, err := New(conns)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer c2.Close()
	if err := c2.EraseAt(1); err != nil {
		t.Fatalf("EraseAt error: %v", err)
	}
	sz, _ := c2.Size()
	if sz != uint32(len(conns)-1) {
		t.Errorf("After EraseAt, Size() = %v, want %v", sz, len(conns)-1)
	}
	if err := c2.Clear(); err != nil {
		t.Fatalf("Clear error: %v", err)
	}
	empty, _ := c2.Empty()
	if !empty {
		t.Errorf("After Clear, Empty() = false, want true")
	}
}

func TestConnections_Intersection(t *testing.T) {
	withConnections(t, func(t *testing.T, c *Handle, conns []*connection.Handle) {
		c2, err := New(conns)
		if err != nil {
			t.Fatalf("New error: %v", err)
		}
		defer c2.Close()
		inter, err := c.Intersection(c2)
		if err != nil {
			t.Fatalf("Intersection error: %v", err)
		}
		defer inter.Close()
		items, err := inter.Items()
		if err != nil {
			t.Fatalf("Intersection Items error: %v", err)
		}
		if size, _ := items.Size(); size != uint32(len(conns)) {
			t.Errorf("Intersection Items = %v, want %v", size, len(conns))
		}
	})
}

func TestConnections_EqualAndNotEqual(t *testing.T) {
	withConnections(t, func(t *testing.T, c *Handle, conns []*connection.Handle) {
		c2, err := New(conns)
		if err != nil {
			t.Fatalf("New error: %v", err)
		}
		defer c2.Close()
		eq, err := c.Equal(c2)
		if err != nil || !eq {
			t.Errorf("Equal = %v, want true, err: %v", eq, err)
		}
		neq, err := c.NotEqual(c2)
		if err != nil || neq {
			t.Errorf("NotEqual = %v, want false, err: %v", neq, err)
		}
	})
}

func TestConnections_ToJSONAndFromJSON(t *testing.T) {
	withConnections(t, func(t *testing.T, c *Handle, conns []*connection.Handle) {
		jsonStr, err := c.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		c2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer c2.Close()
		eq, err := c.Equal(c2)
		if err != nil || !eq {
			t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
		}
	})
}

func TestConnections_ClosedErrors(t *testing.T) {
	conns := makeTestConnections(t)
	c, err := New(conns)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	c.Close()
	if _, err := c.Size(); err == nil {
		t.Error("Size() on closed: expected error")
	}
	if _, err := c.Items(); err == nil {
		t.Error("Items() on closed: expected error")
	}
	if _, err := c.At(0); err == nil {
		t.Error("At() on closed: expected error")
	}
	if _, err := c.Contains(conns[0]); err == nil {
		t.Error("Contains() on closed: expected error")
	}
	if _, err := c.Index(conns[0]); err == nil {
		t.Error("Index() on closed: expected error")
	}
	if _, err := c.Equal(c); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := c.NotEqual(c); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
	if _, err := c.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := c.PushBack(conns[0]); err == nil {
		t.Error("PushBack() on closed: expected error")
	}
	if err := c.EraseAt(0); err == nil {
		t.Error("EraseAt() on closed: expected error")
	}
	if err := c.Clear(); err == nil {
		t.Error("Clear() on closed: expected error")
	}
	if err := c.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestConnections_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestConnections_FromCAPI_Valid(t *testing.T) {
	withConnections(t, func(t *testing.T, c *Handle, _ []*connection.Handle) {
		capi := c.CAPIHandle()
		h, err := FromCAPI(capi)
		if err != nil {
			t.Errorf("FromCAPI valid: unexpected error: %v", err)
		}
		if h == nil {
			t.Fatal("FromCAPI valid: got nil")
		}
	})
}
