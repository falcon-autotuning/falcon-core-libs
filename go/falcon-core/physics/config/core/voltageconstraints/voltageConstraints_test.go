package voltageconstraints

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairdoubledouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/adjacency"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

func makeTestAdjacency(t *testing.T) *adjacency.Handle {
	// Minimal 2x2 adjacency matrix: [0,1,1,0] with shape [2,2]
	data := []int32{0, 1, 1, 0}
	shape := []uint64{2, 2}
	// Create dummy connections for indexes (must be non-nil)
	c1, err := connection.NewBarrierGate("A")
	if err != nil {
		t.Fatalf("NewBarrierGate(A): %v", err)
	}
	c2, err := connection.NewBarrierGate("B")
	if err != nil {
		t.Fatalf("NewBarrierGate(B): %v", err)
	}
	idx, err := connections.New([]*connection.Handle{c1, c2})
	if err != nil {
		t.Fatalf("connections.New: %v", err)
	}
	adj, err := adjacency.New(data, shape, idx)
	if err != nil {
		t.Fatalf("adjacency.Create: %v", err)
	}
	if adj == nil {
		t.Fatal("adjacency.Create returned nil")
	}
	return adj
}

func makeTestPairDoubleDouble(t *testing.T) *pairdoubledouble.Handle {
	pair, err := pairdoubledouble.New(-1.0, 1.0)
	if err != nil {
		t.Fatalf("pairdoubledouble.New error: %v", err)
	}
	if pair == nil {
		t.Fatal("pairdoubledouble.New returned nil")
	}
	return pair
}

func makeTestVoltageConstraints(t *testing.T) (*Handle, *adjacency.Handle, *pairdoubledouble.Handle) {
	adj := makeTestAdjacency(t)
	bounds := makeTestPairDoubleDouble(t)
	vc, err := New(adj, 0.5, bounds)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	if vc == nil {
		t.Fatal("New returned nil")
	}
	return vc, adj, bounds
}

func TestVoltageConstraints_NewAndClose(t *testing.T) {
	vc, _, _ := makeTestVoltageConstraints(t)
	if err := vc.Close(); err != nil {
		t.Fatalf("Close error: %v", err)
	}
	if err := vc.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestVoltageConstraints_MaxSafeDiff(t *testing.T) {
	vc, _, _ := makeTestVoltageConstraints(t)
	mat, err := vc.MaxSafeDiff()
	if err != nil {
		t.Fatalf("MaxSafeDiff error: %v", err)
	}
	if mat == 0.0 {
		t.Error("MaxSafeDiff returned 0.0")
	}
}

func TestVoltageConstraints_MinBound(t *testing.T) {
	vc, _, _ := makeTestVoltageConstraints(t)
	mat, err := vc.MinBound()
	if err != nil {
		t.Fatalf("MinBound error: %v", err)
	}
	if mat == 0.0 {
		t.Error("MinBound returned 0.0")
	}
}

func TestVoltageConstraints_MaxBound(t *testing.T) {
	vc, _, _ := makeTestVoltageConstraints(t)
	mat, err := vc.MaxBound()
	if err != nil {
		t.Fatalf("MaxBound error: %v", err)
	}
	if mat == 0.0 {
		t.Error("MaxBound returned 0.0")
	}
}

func TestVoltageConstraints_Adjacency(t *testing.T) {
	vc, _, _ := makeTestVoltageConstraints(t)
	a, err := vc.Adjacency()
	if err != nil {
		t.Fatalf("Adjacency error: %v", err)
	}
	if a == nil {
		t.Error("Adjacency returned nil")
	}
}

func TestVoltageConstraints_EqualAndNotEqual(t *testing.T) {
	vc1, _, _ := makeTestVoltageConstraints(t)
	vc2, _, _ := makeTestVoltageConstraints(t)
	eq, err := vc1.Equal(vc2)
	if err != nil || !eq {
		t.Errorf("Equal = %v, want true, err: %v", eq, err)
	}
	neq, err := vc1.NotEqual(vc2)
	if err != nil || neq {
		t.Errorf("NotEqual = %v, want false, err: %v", neq, err)
	}
}

func TestVoltageConstraints_ToJSONAndFromJSON(t *testing.T) {
	vc, _, _ := makeTestVoltageConstraints(t)
	jsonStr, err := vc.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON error: %v", err)
	}
	vc2, err := FromJSON(jsonStr)
	if err != nil {
		t.Fatalf("FromJSON error: %v", err)
	}
	eq, err := vc.Equal(vc2)
	if err != nil || !eq {
		t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
	}
}

func TestVoltageConstraints_ClosedErrors(t *testing.T) {
	vc, adj, bounds := makeTestVoltageConstraints(t)
	vc.Close()
	adj.Close()
	bounds.Close()
	if _, err := vc.MaxSafeDiff(); err == nil {
		t.Error("MaxSafeDiff() on closed: expected error")
	}
	if _, err := vc.MaxBound(); err == nil {
		t.Error("MaxBound() on closed: expected error")
	}
	if _, err := vc.MinBound(); err == nil {
		t.Error("MinBound() on closed: expected error")
	}
	if _, err := vc.Adjacency(); err == nil {
		t.Error("Adjacency() on closed: expected error")
	}
	if _, err := vc.Equal(vc); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := vc.NotEqual(vc); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
	if _, err := vc.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := vc.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestVoltageConstraints_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestVoltageConstraints_FromCAPI_Valid(t *testing.T) {
	vc, _, _ := makeTestVoltageConstraints(t)
	capi := vc.CAPIHandle()
	if capi == nil {
		t.Fatal("CAPIHandle returned nil")
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
