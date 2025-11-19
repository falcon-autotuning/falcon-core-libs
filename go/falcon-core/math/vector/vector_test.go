package vector

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/point"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestConnection(t *testing.T, name string) *connection.Handle {
	c, err := connection.NewPlungerGate(name)
	if err != nil {
		t.Fatalf("connection.NewPlungerGate failed: %v", err)
	}
	return c
}

func makeTestSymbolUnit(t *testing.T) *symbolunit.Handle {
	u, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("symbolunit.NewVolt failed: %v", err)
	}
	return u
}

func makeTestPairQuantityQuantity(t *testing.T) *pairquantityquantity.Handle {
	q1, err := quantity.New(1.1, makeTestSymbolUnit(t))
	if err != nil {
		t.Fatalf("the first quantity could not be assembled")
	}
	q2, err := quantity.New(2.2, makeTestSymbolUnit(t))
	if err != nil {
		t.Fatalf("the second quantity could not be assembled")
	}
	p, err := pairquantityquantity.New(q1, q2)
	if err != nil {
		t.Fatalf("pairquantityquantity.NewFromFloat64 failed: %v", err)
	}
	return p
}

func makeTestMapConnectionQuantity(t *testing.T) *mapconnectionquantity.Handle {
	conn := makeTestConnection(t, "A")
	defer conn.Close()
	q1, err := quantity.New(1.1, makeTestSymbolUnit(t))
	if err != nil {
		t.Fatalf("the first quantity could not be assembled")
	}
	pair, err := pairconnectionquantity.New(conn, q1)
	if err != nil {
		t.Fatalf("pairquantityquantity.NewFromFloat64 failed: %v", err)
	}
	m, err := mapconnectionquantity.New([]*pairconnectionquantity.Handle{pair})
	if err != nil {
		t.Fatalf("mapconnectionquantity.New failed: %v", err)
	}
	return m
}

func makeTestMapConnectionDouble(t *testing.T) *mapconnectiondouble.Handle {
	conn := makeTestConnection(t, "A")
	defer conn.Close()
	pair, err := pairconnectiondouble.New(conn, 2.2)
	if err != nil {
		t.Fatalf("pairquantityquantity.NewFromFloat64 failed: %v", err)
	}
	m, err := mapconnectiondouble.New([]*pairconnectiondouble.Handle{pair})
	if err != nil {
		t.Fatalf("mapconnectiondouble.New failed: %v", err)
	}
	return m
}

func makeTestPoint(t *testing.T) *point.Handle {
	m := makeTestMapConnectionDouble(t)
	defer m.Close()
	u := makeTestSymbolUnit(t)
	defer u.Close()
	p, err := point.Create(m, u)
	if err != nil {
		t.Fatalf("point.Create failed: %v", err)
	}
	return p
}

func makeTestDeviceVoltageStates(t *testing.T) *devicevoltagestates.Handle {
	h, err := devicevoltagestates.NewEmpty()
	if err != nil {
		t.Fatalf("devicevoltagestates.NewEmpty failed: %v", err)
	}
	return h
}

func TestVector_FullCoverage(t *testing.T) {
	start := makeTestPoint(t)
	defer start.Close()
	end := makeTestPoint(t)
	defer end.Close()
	v, err := New(start, end)
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer v.Close()
	ptr, err := v.CAPIHandle()
	if err != nil || ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}
	ep, err := v.EndPoint()
	if err != nil {
		t.Errorf("EndPoint failed: %v", err)
	}
	if ep != nil {
		defer ep.Close()
	}
	sp, err := v.StartPoint()
	if err != nil {
		t.Errorf("StartPoint failed: %v", err)
	}
	if sp != nil {
		defer sp.Close()
	}

	_, err = v.Magnitude()
	if err != nil {
		t.Errorf("Magnitude failed: %v", err)
	}

	unit := makeTestSymbolUnit(t)
	defer unit.Close()
	_ = v.UpdateUnit(unit)
	u, err := v.Unit()
	if err != nil {
		t.Errorf("Unit failed: %v", err)
	}
	if u != nil {
		defer u.Close()
	}

	pc, err := v.PrincipleConnection()
	if err != nil {
		t.Errorf("PrincipleConnection failed: %v", err)
	}
	if pc != nil {
		defer pc.Close()
	}

	eq, err := v.EndQuantities()
	if err != nil {
		t.Errorf("EndQuantities failed: %v", err)
	}
	if eq != nil {
		defer eq.Close()
	}
	sq, err := v.StartQuantities()
	if err != nil {
		t.Errorf("StartQuantities failed: %v", err)
	}
	if sq != nil {
		defer sq.Close()
	}

	em, err := v.EndMap()
	if err != nil {
		t.Errorf("EndMap failed: %v", err)
	}
	if em != nil {
		defer em.Close()
	}
	sm, err := v.StartMap()
	if err != nil {
		t.Errorf("StartMap failed: %v", err)
	}
	if sm != nil {
		defer sm.Close()
	}

	conns, err := v.Connections()
	if err != nil {
		t.Errorf("Connections failed: %v", err)
	}
	if conns != nil {
		defer conns.Close()
	}

	keys, err := v.Keys()
	if err != nil {
		t.Errorf("Keys failed: %v", err)
	}
	if keys != nil {
		defer keys.Close()
	}
	vals, err := v.Values()
	if err != nil {
		t.Errorf("Values failed: %v", err)
	}
	if vals != nil {
		defer vals.Close()
	}
	items, err := v.Items()
	if err != nil {
		t.Errorf("Items failed: %v", err)
	}
	if items != nil {
		defer items.Close()
	}

	conn := makeTestConnection(t, "B")
	defer conn.Close()
	pqq := makeTestPairQuantityQuantity(t)
	defer pqq.Close()
	if err := v.InsertOrAssign(conn, pqq); err != nil {
		t.Errorf("InsertOrAssign failed: %v", err)
	}
	if err := v.Insert(conn, pqq); err != nil {
		t.Errorf("Insert failed: %v", err)
	}
	_, err = v.At(conn)
	if err != nil {
		t.Errorf("At failed: %v", err)
	}
	if err := v.Erase(conn); err != nil {
		t.Errorf("Erase failed: %v", err)
	}
	_, err = v.Contains(conn)
	if err != nil {
		t.Errorf("Contains failed: %v", err)
	}

	_, err = v.Size()
	if err != nil {
		t.Errorf("Size failed: %v", err)
	}
	_, err = v.Empty()
	if err != nil {
		t.Errorf("Empty failed: %v", err)
	}

	// --- Isolate destructive Clear() and post-clear tests ---
	t.Run("Clear and post-clear", func(t *testing.T) {
		start2 := makeTestPoint(t)
		defer start2.Close()
		end2 := makeTestPoint(t)
		defer end2.Close()
		v2, err := New(start2, end2)
		if err != nil {
			t.Fatalf("New failed: %v", err)
		}
		defer v2.Close()
		if err := v2.Clear(); err != nil {
			t.Errorf("Clear failed: %v", err)
		}
		// After clear, only test that Clear does not panic or error on empty vector.
	})

	// --- Arithmetic and transformation methods (must be before Clear) ---
	other := makeTestPoint(t)
	defer other.Close()
	v2, err := New(start, end)
	if err != nil {
		t.Fatalf("New (other) failed: %v", err)
	}
	defer v2.Close()
	_, err = v.Addition(v2)
	if err != nil {
		t.Errorf("Addition failed: %v", err)
	}
	_, err = v.Subtraction(v2)
	if err != nil {
		t.Errorf("Subtraction failed: %v", err)
	}
	_, err = v.DoubleMultiplication(2.0)
	if err != nil {
		t.Errorf("DoubleMultiplication failed: %v", err)
	}
	_, err = v.IntMultiplication(2)
	if err != nil {
		t.Errorf("IntMultiplication failed: %v", err)
	}
	_, err = v.DoubleDivision(2.0)
	if err != nil {
		t.Errorf("DoubleDivision failed: %v", err)
	}
	_, err = v.IntDivision(2)
	if err != nil {
		t.Errorf("IntDivision failed: %v", err)
	}
	_, err = v.Negation()
	if err != nil {
		t.Errorf("Negation failed: %v", err)
	}
	_, err = v.UnitVector()
	if err != nil {
		t.Errorf("UnitVector failed: %v", err)
	}
	_, err = v.Normalize()
	if err != nil {
		t.Errorf("Normalize failed: %v", err)
	}
	_, err = v.Project(v2)
	if err != nil {
		t.Errorf("Project failed: %v", err)
	}
	_, err = v.DoubleExtend(1.0)
	if err != nil {
		t.Errorf("DoubleExtend failed: %v", err)
	}
	_, err = v.IntExtend(1)
	if err != nil {
		t.Errorf("IntExtend failed: %v", err)
	}
	_, err = v.DoubleShrink(1.0)
	if err != nil {
		t.Errorf("DoubleShrink failed: %v", err)
	}
	_, err = v.IntShrink(1)
	if err != nil {
		t.Errorf("IntShrink failed: %v", err)
	}
	_, err = v.TranslateToOrigin()
	if err != nil {
		t.Errorf("TranslateToOrigin failed: %v", err)
	}
	_, err = v.Translate(end)
	if err != nil {
		t.Errorf("Translate failed: %v", err)
	}
	mcd := makeTestMapConnectionDouble(t)
	defer mcd.Close()
	_, err = v.TranslateDoubles(mcd, unit)
	if err != nil {
		t.Errorf("TranslateDoubles failed: %v", err)
	}
	mcq := makeTestMapConnectionQuantity(t)
	defer mcq.Close()
	_, err = v.TranslateQuantities(mcq)
	if err != nil {
		t.Errorf("TranslateQuantities failed: %v", err)
	}
	_, err = v.UpdateStartFromStates(makeTestDeviceVoltageStates(t))
	if err != nil {
		t.Errorf("UpdateStartFromStates failed: %v", err)
	}

	eqBool, err := v.Equal(v2)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	neqBool, err := v.NotEqual(v2)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	if eqBool && neqBool {
		t.Errorf("Equal and NotEqual both true")
	}

	jsonstr, err := v.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	v3, err := FromJSON(jsonstr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	if v3 != nil {
		defer v3.Close()
		eq2, _ := v.Equal(v3)
		if !eq2 {
			t.Errorf("Expected Equal true for original and FromJSON")
		}
	}

	_, err = FromCAPI(nil)
	if err == nil {
		t.Errorf("FromCAPI(nil) should error")
	}
	_, err = v.Addition(nil)
	if err == nil {
		t.Errorf("Addition with nil should error")
	}
	_, err = v.Subtraction(nil)
	if err == nil {
		t.Errorf("Subtraction with nil should error")
	}
	_, err = v.Project(nil)
	if err == nil {
		t.Errorf("Project with nil should error")
	}
	_, err = v.Equal(nil)
	if err == nil {
		t.Errorf("Equal with nil should error")
	}
	_, err = v.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual with nil should error")
	}

	v.Close()
	_, err = v.CAPIHandle()
	if err == nil {
		t.Errorf("CAPIHandle on closed should error")
	}
	err = v.Close()
	if err == nil {
		t.Errorf("Second close should error")
	}
	_, err = v.EndPoint()
	if err == nil {
		t.Errorf("EndPoint on closed should error")
	}
	_, err = v.StartPoint()
	if err == nil {
		t.Errorf("StartPoint on closed should error")
	}
	_, err = v.EndQuantities()
	if err == nil {
		t.Errorf("EndQuantities on closed should error")
	}
	_, err = v.StartQuantities()
	if err == nil {
		t.Errorf("StartQuantities on closed should error")
	}
	_, err = v.EndMap()
	if err == nil {
		t.Errorf("EndMap on closed should error")
	}
	_, err = v.StartMap()
	if err == nil {
		t.Errorf("StartMap on closed should error")
	}
	_, err = v.Connections()
	if err == nil {
		t.Errorf("Connections on closed should error")
	}
	_, err = v.Unit()
	if err == nil {
		t.Errorf("Unit on closed should error")
	}
	_, err = v.PrincipleConnection()
	if err == nil {
		t.Errorf("PrincipleConnection on closed should error")
	}
	_, err = v.Magnitude()
	if err == nil {
		t.Errorf("Magnitude on closed should error")
	}
	err = v.InsertOrAssign(conn, pqq)
	if err == nil {
		t.Errorf("InsertOrAssign on closed should error")
	}
	err = v.Insert(conn, pqq)
	if err == nil {
		t.Errorf("Insert on closed should error")
	}
	_, err = v.At(conn)
	if err == nil {
		t.Errorf("At on closed should error")
	}
	err = v.Erase(conn)
	if err == nil {
		t.Errorf("Erase on closed should error")
	}
	_, err = v.Size()
	if err == nil {
		t.Errorf("Size on closed should error")
	}
	_, err = v.Empty()
	if err == nil {
		t.Errorf("Empty on closed should error")
	}
	_, err = v.Contains(conn)
	if err == nil {
		t.Errorf("Contains on closed should error")
	}
	_, err = v.Keys()
	if err == nil {
		t.Errorf("Keys on closed should error")
	}
	_, err = v.Values()
	if err == nil {
		t.Errorf("Values on closed should error")
	}
	_, err = v.Items()
	if err == nil {
		t.Errorf("Items on closed should error")
	}
	_, err = v.Addition(v2)
	if err == nil {
		t.Errorf("Addition on closed should error")
	}
	_, err = v.Subtraction(v2)
	if err == nil {
		t.Errorf("Subtraction on closed should error")
	}
	_, err = v.DoubleMultiplication(2.0)
	if err == nil {
		t.Errorf("DoubleMultiplication on closed should error")
	}
	_, err = v.IntMultiplication(2)
	if err == nil {
		t.Errorf("IntMultiplication on closed should error")
	}
	_, err = v.DoubleDivision(2.0)
	if err == nil {
		t.Errorf("DoubleDivision on closed should error")
	}
	_, err = v.IntDivision(2)
	if err == nil {
		t.Errorf("IntDivision on closed should error")
	}
	_, err = v.Negation()
	if err == nil {
		t.Errorf("Negation on closed should error")
	}
	_, err = v.UnitVector()
	if err == nil {
		t.Errorf("UnitVector on closed should error")
	}
	_, err = v.Normalize()
	if err == nil {
		t.Errorf("Normalize on closed should error")
	}
	_, err = v.Project(v2)
	if err == nil {
		t.Errorf("Project on closed should error")
	}
	_, err = v.DoubleExtend(1.0)
	if err == nil {
		t.Errorf("DoubleExtend on closed should error")
	}
	_, err = v.IntExtend(1)
	if err == nil {
		t.Errorf("IntExtend on closed should error")
	}
	_, err = v.DoubleShrink(1.0)
	if err == nil {
		t.Errorf("DoubleShrink on closed should error")
	}
	_, err = v.IntShrink(1)
	if err == nil {
		t.Errorf("IntShrink on closed should error")
	}
	_, err = v.TranslateToOrigin()
	if err == nil {
		t.Errorf("TranslateToOrigin on closed should error")
	}
	_, err = v.Translate(end)
	if err == nil {
		t.Errorf("Translate on closed should error")
	}
	_, err = v.TranslateDoubles(mcd, unit)
	if err == nil {
		t.Errorf("TranslateDoubles on closed should error")
	}
	_, err = v.TranslateQuantities(mcq)
	if err == nil {
		t.Errorf("TranslateQuantities on closed should error")
	}
	_, err = v.UpdateStartFromStates(makeTestDeviceVoltageStates(t))
	if err == nil {
		t.Errorf("UpdateStartFromStates on closed should error")
	}
	_, err = v.ToJSON()
	if err == nil {
		t.Errorf("ToJSON on closed should error")
	}
}
