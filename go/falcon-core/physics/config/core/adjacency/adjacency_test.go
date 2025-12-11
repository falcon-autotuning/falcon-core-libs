package adjacency

import (
	"reflect"
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farrayint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

var (
	defaultShape = []uint64{2, 2}
	defaultData  = []int32{1, 2, 3, 4}
)

func makeConnections(t *testing.T) *connections.Handle {
	conn, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("Failed to create connections: %v", err)
	}
	gate, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf("Failed to create barrier gate: %v", err)
	}
	conn.PushBack(gate)
	return conn
}

func makeFArrayInt(t *testing.T) *farrayint.Handle {
	int32Data := make([]int32, len(defaultData))
	for i, v := range defaultData {
		int32Data[i] = int32(v)
	}
	a, err := farrayint.FromData(int32Data, defaultShape)
	if err != nil {
		t.Fatalf("Failed to create farrayint: %v", err)
	}
	if a == nil {
		t.Fatal("farrayint is nil after creation")
	}
	return a
}

func TestAdjacency_CreateAndData(t *testing.T) {
	conn := makeConnections(t)
	a, err := New(defaultData, defaultShape, conn)
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}
	data, err := a.Data()
	if err != nil {
		t.Fatalf("Data failed: %v", err)
	}
	if !reflect.DeepEqual(data, defaultData) {
		t.Errorf("Expected %v, got %v", defaultData, data)
	}
}

func TestAdjacency_ShapeDimensionSize(t *testing.T) {
	conn := makeConnections(t)
	a, _ := New(defaultData, defaultShape, conn)
	shape, err := a.Shape()
	if err != nil {
		t.Fatalf("Shape failed: %v", err)
	}
	if !reflect.DeepEqual(shape, defaultShape) {
		t.Errorf("Expected shape %v, got %v", defaultShape, shape)
	}
	dim, err := a.Dimension()
	if err != nil {
		t.Fatalf("Dimension failed: %v", err)
	}
	if dim != uint64(len(defaultShape)) {
		t.Errorf("Expected dimension %d, got %d", len(defaultShape), dim)
	}
	sz, err := a.Size()
	if err != nil {
		t.Fatalf("Size failed: %v", err)
	}
	if sz != 4 {
		t.Errorf("Expected size 4, got %d", sz)
	}
}

func TestAdjacency_IndexesAndGetTruePairs(t *testing.T) {
	conn := makeConnections(t)
	a, _ := New(defaultData, defaultShape, conn)
	ind, err := a.Indexes()
	if err != nil {
		t.Errorf("Indexes failed: %v", err)
	}
	ok, err := ind.Equal(conn)
	if err != nil {
		t.Errorf("Equality failed: %v", err)
	}
	if !ok {
		t.Errorf("Indexes are not equal coming back from C-API")
	}
	_, err = a.GetTruePairs()
	if err != nil {
		t.Errorf("GetTruePairs failed: %v", err)
	}
}

func TestAdjacency_TimesEqualsFArray(t *testing.T) {
	conn := makeConnections(t)
	a, err := New(defaultData, defaultShape, conn)
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}
	if a == nil {
		t.Fatal("Adjacency is nil after creation")
	}
	fa := makeFArrayInt(t)
	if err := a.TimesEqualsFArray(fa); err != nil {
		t.Errorf("TimesEqualsFArray failed: %v", err)
	}
}

func TestAdjacency_TimesFArray(t *testing.T) {
	conn := makeConnections(t)
	a, _ := New(defaultData, defaultShape, conn)
	fa := makeFArrayInt(t)
	_, err := a.TimesFArray(fa)
	if err != nil {
		t.Errorf("TimesFArray failed: %v", err)
	}
}

func TestAdjacency_EqualAndNotEqual(t *testing.T) {
	conn := makeConnections(t)
	a, err := New(defaultData, defaultShape, conn)
	if err != nil {
		t.Fatalf("Adjacency a New failed: %v", err)
	}
	b, err := New(defaultData, defaultShape, conn)
	if err != nil {
		t.Fatalf("Adjacency b New failed: %v", err)
	}
	ok, err := a.Equal(b)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	_ = ok
	ok, err = a.NotEqual(b)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	_ = ok
}

func TestAdjacency_Sum(t *testing.T) {
	conn := makeConnections(t)
	a, _ := New(defaultData, defaultShape, conn)
	_, err := a.Sum()
	if err != nil {
		t.Errorf("Sum failed: %v", err)
	}
}

func TestAdjacency_WhereFlip(t *testing.T) {
	conn := makeConnections(t)
	a, _ := New(defaultData, defaultShape, conn)
	_, err := a.Where(2)
	if err != nil {
		t.Errorf("Where failed: %v", err)
	}
	_, err = a.Flip(0)
	if err != nil {
		t.Errorf("Flip failed: %v", err)
	}
}

func TestAdjacency_ToJSONAndFromJSON(t *testing.T) {
	conn := makeConnections(t)
	a, _ := New(defaultData, defaultShape, conn)
	js, err := a.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON failed: %v", err)
	}
	b, err := FromJSON(js)
	if err != nil {
		t.Fatalf("FromJSON failed: %v", err)
	}
	data, err := b.Data()
	if err != nil {
		t.Fatalf("Data failed: %v", err)
	}
	if !reflect.DeepEqual(data, defaultData) {
		t.Errorf("Expected %v, got %v", defaultData, data)
	}
}

func TestAdjacency_ErrorBranches(t *testing.T) {
	conn := makeConnections(t)
	a, _ := New(defaultData, defaultShape, conn)
	a.Close()
	_, err := a.Size()
	if err == nil {
		t.Error("Expected error on Size after Close")
	}
	_, err = a.Dimension()
	if err == nil {
		t.Error("Expected error on Dimension after Close")
	}
	_, err = a.Shape()
	if err == nil {
		t.Error("Expected error on Shape after Close")
	}
	_, err = a.Data()
	if err == nil {
		t.Error("Expected error on Data after Close")
	}
	_, err = a.TimesFArray(nil)
	if err == nil {
		t.Error("Expected error on TimesFArray with nil")
	}
	_, err = a.Equal(nil)
	if err == nil {
		t.Error("Expected error on Equal with nil")
	}
	_, err = a.NotEqual(nil)
	if err == nil {
		t.Error("Expected error on NotEqual with nil")
	}
}
