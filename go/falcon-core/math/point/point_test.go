package point

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestPoint(t *testing.T) (*Handle, []*connection.Handle, []*quantity.Handle, *symbolunit.Handle) {
	conns := []*connection.Handle{}
	vals := []*quantity.Handle{}
	for i, name := range []string{"A", "B", "C"} {
		c, err := connection.NewBarrierGate(name)
		if err != nil {
			t.Fatalf("connection.NewBarrierGate(%q): %v", name, err)
		}
		v, err := symbolunit.NewVolt()
		if err != nil {
			t.Fatalf("the symbolunit could not make a volt: %v", err)
		}
		q, err := quantity.New(float64(i+1), v)
		if err != nil {
			t.Fatalf("quantity.NewFloat64(%d): %v", i+1, err)
		}
		conns = append(conns, c)
		vals = append(vals, q)
	}
	unit, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("symbolunit.NewVolt: %v", err)
	}
	mcd, err := mapconnectiondouble.NewEmpty()
	if err != nil {
		t.Fatalf("mapconnectiondouble.NewEmpty: %v", err)
	}
	for i, c := range conns {
		if err := mcd.Insert(c, float64(i+1)); err != nil {
			t.Fatalf("mcd.Insert: %v", err)
		}
	}
	pt, err := New(mcd, unit)
	if err != nil {
		t.Fatalf("Create: %v", err)
	}
	return pt, conns, vals, unit
}

func withPoint(t *testing.T, fn func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle)) {
	pt, conns, vals, unit := makeTestPoint(t)
	defer pt.Close()
	fn(t, pt, conns, vals, unit)
}

func TestPoint_SizeAndEmpty(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
		sz, err := pt.Size()
		if err != nil {
			t.Fatalf("Size error: %v", err)
		}
		if sz != uint64(len(conns)) {
			t.Errorf("Size = %v, want %v", sz, len(conns))
		}
		empty, err := pt.Empty()
		if err != nil {
			t.Fatalf("Empty error: %v", err)
		}
		if empty {
			t.Errorf("Empty = true, want false")
		}
	})
}

func TestPoint_KeysValuesItemsConnections(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
		keys, err := pt.Keys()
		if err != nil {
			t.Fatalf("Keys error: %v", err)
		}
		if size, _ := keys.Size(); size != uint64(len(conns)) {
			t.Errorf("Keys len = %v, want %v", size, len(conns))
		}
		values, err := pt.Values()
		if err != nil {
			t.Fatalf("Values error: %v", err)
		}
		valSlice, err := values.Items()
		if err != nil {
			t.Fatalf("Values.Items error: %v", err)
		}
		if len(valSlice) != len(conns) {
			t.Errorf("Values len = %v, want %v", len(valSlice), len(conns))
		}
		items, err := pt.Items()
		if err != nil {
			t.Fatalf("Items error: %v", err)
		}
		itemSlice, err := items.Items()
		if err != nil {
			t.Fatalf("Items.Items error: %v", err)
		}
		if len(itemSlice) != len(conns) {
			t.Errorf("Items len = %v, want %v", len(itemSlice), len(conns))
		}
		connections, err := pt.Connections()
		if err != nil {
			t.Fatalf("Connections error: %v", err)
		}
		if size, _ := connections.Size(); size != uint64(len(conns)) {
			t.Errorf("Connections len = %v, want %v", size, len(conns))
		}
	})
}

func TestPoint_AtInsertEraseInsertOrAssign(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
		v, err := symbolunit.NewVolt()
		if err != nil {
			t.Fatalf("the symbolunit could not make a volt: %v", err)
		}
		for i, c := range conns {
			got, err := pt.At(c)
			if err != nil {
				t.Fatalf("At(%d) error: %v", i, err)
			}
			want, _ := quantity.New(float64(i+1), v)
			eq, err := got.Equal(want)
			if err != nil || !eq {
				t.Errorf("At(%d) = %v, want %v", i, got, want)
			}
		}
		// Erase and check
		if err := pt.Erase(conns[0]); err != nil {
			t.Fatalf("Erase error: %v", err)
		}
		ok, err := pt.Contains(conns[0])
		if err != nil {
			t.Fatalf("Contains error: %v", err)
		}
		if ok {
			t.Errorf("Contains after erase = true, want false")
		}
		// Insert
		val, _ := quantity.New(99, v)
		if err := pt.Insert(conns[0], val); err != nil {
			t.Fatalf("Insert error: %v", err)
		}
		got, err := pt.At(conns[0])
		if err != nil {
			t.Fatalf("At after Insert error: %v", err)
		}
		eq, err := got.Equal(val)
		if err != nil || !eq {
			t.Errorf("At after Insert = %v, want %v", got, val)
		}
		// InsertOrAssign
		val2, _ := quantity.New(123, v)
		if err := pt.InsertOrAssign(conns[0], val2); err != nil {
			t.Fatalf("InsertOrAssign error: %v", err)
		}
		got, err = pt.At(conns[0])
		if err != nil {
			t.Fatalf("At after InsertOrAssign error: %v", err)
		}
		eq, err = got.Equal(val2)
		if err != nil || !eq {
			t.Errorf("At after InsertOrAssign = %v, want %v", got, val2)
		}
	})
}

func TestPoint_Clear(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
		if err := pt.Clear(); err != nil {
			t.Fatalf("Clear error: %v", err)
		}
		sz, err := pt.Size()
		if err != nil {
			t.Fatalf("Size after Clear error: %v", err)
		}
		if sz != 0 {
			t.Errorf("Size after Clear = %v, want 0", sz)
		}
		empty, err := pt.Empty()
		if err != nil {
			t.Fatalf("Empty after Clear error: %v", err)
		}
		if !empty {
			t.Errorf("Empty after Clear = false, want true")
		}
	})
}

func TestPoint_UnitSetUnit(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
		got, err := pt.Unit()
		if err != nil {
			t.Fatalf("Unit error: %v", err)
		}
		eq, err := got.Equal(unit)
		if err != nil || !eq {
			t.Errorf("Unit = %v, want %v", got, unit)
		}
		ohm, err := symbolunit.NewOhm()
		if err != nil {
			t.Fatalf("symbolunit.NewOhm error: %v", err)
		}
		if err := pt.SetUnit(ohm); err != nil {
			t.Fatalf("SetUnit error: %v", err)
		}
		got2, err := pt.Unit()
		if err != nil {
			t.Fatalf("Unit after SetUnit error: %v", err)
		}
		eq2, err := got2.Equal(ohm)
		if err != nil || eq2 {
			t.Errorf("Unit after SetUnit = %v, want %v", got2, ohm)
		}
	})
}

func TestPoint_Arithmetic(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
		pt2, _, _, _ := makeTestPoint(t)
		defer pt2.Close()
		add, err := pt.Addition(pt2)
		if err != nil {
			t.Fatalf("Addition error: %v", err)
		}
		defer add.Close()
		sub, err := pt.Subtraction(pt2)
		if err != nil {
			t.Fatalf("Subtraction error: %v", err)
		}
		defer sub.Close()
		mul, err := pt.Multiplication(2)
		if err != nil {
			t.Fatalf("Multiplication error: %v", err)
		}
		defer mul.Close()
		div, err := pt.Division(2)
		if err != nil {
			t.Fatalf("Division error: %v", err)
		}
		defer div.Close()
		neg, err := pt.Negation()
		if err != nil {
			t.Fatalf("Negation error: %v", err)
		}
		defer neg.Close()
	})
}

func TestPoint_EqualNotEqual(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
		pt2, _, _, _ := makeTestPoint(t)
		defer pt2.Close()
		eq, err := pt.Equal(pt2)
		if err != nil {
			t.Fatalf("Equal error: %v", err)
		}
		if !eq {
			t.Errorf("Equal = false, want true")
		}
		neq, err := pt.NotEqual(pt2)
		if err != nil {
			t.Fatalf("NotEqual error: %v", err)
		}
		if neq {
			t.Errorf("NotEqual = true, want false")
		}
	})
}

func TestPoint_Coordinates(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
		coords, err := pt.Coordinates()
		if err != nil {
			t.Fatalf("Coordinates error: %v", err)
		}
		if coords == nil {
			t.Error("Coordinates = nil, want non-nil")
		}
	})
}

func TestPoint_ToJSONAndFromJSON(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
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

func TestPoint_ClosedErrors(t *testing.T) {
	pt, conns, vals, unit := makeTestPoint(t)
	pt.Close()
	if _, err := pt.Size(); err == nil {
		t.Error("Size() on closed: expected error")
	}
	if _, err := pt.Items(); err == nil {
		t.Error("Items() on closed: expected error")
	}
	if _, err := pt.At(conns[0]); err == nil {
		t.Error("At() on closed: expected error")
	}
	if _, err := pt.Contains(conns[0]); err == nil {
		t.Error("Contains() on closed: expected error")
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
	if err := pt.Insert(conns[0], vals[0]); err == nil {
		t.Error("Insert() on closed: expected error")
	}
	if err := pt.InsertOrAssign(conns[0], vals[0]); err == nil {
		t.Error("InsertOrAssign() on closed: expected error")
	}
	if err := pt.Erase(conns[0]); err == nil {
		t.Error("Erase() on closed: expected error")
	}
	if err := pt.Clear(); err == nil {
		t.Error("Clear() on closed: expected error")
	}
	if err := pt.SetUnit(unit); err == nil {
		t.Error("SetUnit() on closed: expected error")
	}
	if _, err := pt.Unit(); err == nil {
		t.Error("Unit() on closed: expected error")
	}
	if _, err := pt.Keys(); err == nil {
		t.Error("Keys() on closed: expected error")
	}
	if _, err := pt.Values(); err == nil {
		t.Error("Values() on closed: expected error")
	}
	if _, err := pt.Coordinates(); err == nil {
		t.Error("Coordinates() on closed: expected error")
	}
	if _, err := pt.Connections(); err == nil {
		t.Error("Connections() on closed: expected error")
	}
	if _, err := pt.Addition(pt); err == nil {
		t.Error("Addition() on closed: expected error")
	}
	if _, err := pt.Subtraction(pt); err == nil {
		t.Error("Subtraction() on closed: expected error")
	}
	if _, err := pt.Multiplication(2); err == nil {
		t.Error("Multiplication() on closed: expected error")
	}
	if _, err := pt.Division(2); err == nil {
		t.Error("Division() on closed: expected error")
	}
	if _, err := pt.Negation(); err == nil {
		t.Error("Negation() on closed: expected error")
	}
	if err := pt.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestPoint_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestPoint_FromCAPI_Valid(t *testing.T) {
	withPoint(t, func(t *testing.T, pt *Handle, conns []*connection.Handle, vals []*quantity.Handle, unit *symbolunit.Handle) {
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
