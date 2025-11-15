package listFloat

import (
	"reflect"
	"testing"
)

// fixtureListData returns the default test data for filling lists.
var defaultListData = []float64{1.1, 2.2}

func fixtureListData() []float64 {
	return defaultListData
}

func TestListFloat_All(t *testing.T) {
	// --- NewEmpty and PushBack ---
	l := NewEmpty()
	defer l.Close()
	if sz, err := l.Size(); err != nil || sz != 0 {
		t.Fatalf("Expected size 0, got %d, err: %v", sz, err)
	}
	for i, v := range fixtureListData() {
		if err := l.PushBack(v); err != nil {
			t.Fatalf("PushBack failed at %d: %v", i, err)
		}
	}
	if sz, _ := l.Size(); sz != len(fixtureListData()) {
		t.Errorf("Expected size %d, got %d", len(fixtureListData()), sz)
	}

	// --- NewAllocate and NewFillValue ---
	l2 := NewAllocate(3)
	defer l2.Close()
	if sz, _ := l2.Size(); sz != 3 {
		t.Errorf("Expected size 3, got %d", sz)
	}
	l3 := NewFillValue(2, 7.7)
	defer l3.Close()
	for i := 0; i < 2; i++ {
		val, err := l3.At(i)
		if err != nil || val != 7.7 {
			t.Errorf("Expected 7.7 at %d, got %v, err: %v", i, val, err)
		}
	}

	// --- New from slice and Items ---
	data := fixtureListData()
	l4 := New(data)
	defer l4.Close()
	items, err := l4.Items()
	if err != nil {
		t.Fatalf("Items failed: %v", err)
	}
	if !reflect.DeepEqual(items, data) {
		t.Errorf("Expected %v, got %v", data, items)
	}

	// --- EraseAt and Clear ---
	l5 := New(fixtureListData())
	defer l5.Close()
	if err := l5.EraseAt(1); err != nil {
		t.Fatalf("EraseAt failed: %v", err)
	}
	items, _ = l5.Items()
	expected := append(fixtureListData()[:1], fixtureListData()[2:]...)
	if !reflect.DeepEqual(items, expected) {
		t.Errorf("Expected %v after erase, got %v", expected, items)
	}
	if err := l5.Clear(); err != nil {
		t.Fatalf("Clear failed: %v", err)
	}
	if empty, _ := l5.Empty(); !empty {
		t.Errorf("Expected list to be empty after Clear")
	}

	// --- Contains and Index ---
	l6 := New(fixtureListData())
	defer l6.Close()
	ok, err := l6.Contains(2.2)
	if err != nil || !ok {
		t.Errorf("Expected Contains(2.2) true, got %v, err: %v", ok, err)
	}
	idx, err := l6.Index(2.2)
	if err != nil || idx != 1 {
		t.Errorf("Expected Index(2.2) == 1, got %d, err: %v", idx, err)
	}

	// --- Intersection, Equal, NotEqual ---
	a := New(fixtureListData())
	defer a.Close()
	b := New(fixtureListData())
	defer b.Close()
	inter, err := a.Intersection(b)
	if err != nil {
		t.Fatalf("Intersection failed: %v", err)
	}
	defer inter.Close()
	items, _ = inter.Items()
	if !reflect.DeepEqual(items, fixtureListData()) {
		t.Errorf("Intersection did not match: %v", items)
	}
	eq, err := a.Equal(b)
	if err != nil || !eq {
		t.Errorf("Expected Equal true, got %v, err: %v", eq, err)
	}
	neq, err := a.NotEqual(New([]float64{1.1}))
	if err != nil || !neq {
		t.Errorf("Expected NotEqual true, got %v, err: %v", neq, err)
	}

	// --- ToJSON and FromJSON ---
	l7 := New(fixtureListData())
	defer l7.Close()
	jsonStr, err := l7.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON failed: %v", err)
	}
	l8 := FromJSON(jsonStr)
	defer l8.Close()
	items, err = l8.Items()
	if err != nil {
		t.Fatalf("Items failed: %v", err)
	}
	if !reflect.DeepEqual(items, fixtureListData()) {
		t.Errorf("FromJSON did not restore correct values: %v", items)
	}
}
