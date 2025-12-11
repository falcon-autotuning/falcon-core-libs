package gategeometryarray1d

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

// Setup function matching the C++ config
type testConfig struct {
	linear    *connections.Handle
	screening *connections.Handle
	gga       *Handle
}

func setupGateGeometryArray1D(t *testing.T) *testConfig {
	t.Helper()
	var connList []*connection.Handle

	o1, err := connection.NewOhmic("O1")
	if err != nil {
		t.Fatalf("NewOhmic(O1): %v", err)
	}
	r1, err := connection.NewReservoirGate("R1")
	if err != nil {
		t.Fatalf("NewReservoirGate(R1): %v", err)
	}
	b1, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf("NewBarrierGate(B1): %v", err)
	}
	p1, err := connection.NewPlungerGate("P1")
	if err != nil {
		t.Fatalf("NewPlungerGate(P1): %v", err)
	}
	b2, err := connection.NewBarrierGate("B2")
	if err != nil {
		t.Fatalf("NewBarrierGate(B2): %v", err)
	}
	r2, err := connection.NewReservoirGate("R2")
	if err != nil {
		t.Fatalf("NewReservoirGate(R2): %v", err)
	}
	o2, err := connection.NewOhmic("O2")
	if err != nil {
		t.Fatalf("NewOhmic(O2): %v", err)
	}
	connList = []*connection.Handle{o1, r1, b1, p1, b2, r2, o2}
	linear, err := connections.New(connList)
	if err != nil {
		t.Fatalf("connections.New(linear): %v", err)
	}

	s1, err := connection.NewScreeningGate("S1")
	if err != nil {
		t.Fatalf("NewScreeningGate(S1): %v", err)
	}
	s2, err := connection.NewScreeningGate("S2")
	if err != nil {
		t.Fatalf("NewScreeningGate(S2): %v", err)
	}
	screening, err := connections.New([]*connection.Handle{s1, s2})
	if err != nil {
		t.Fatalf("connections.New(screening): %v", err)
	}

	gga, err := New(linear, screening)
	if err != nil {
		t.Fatalf("Create(linear, screening): %v", err)
	}

	return &testConfig{
		linear:    linear,
		screening: screening,
		gga:       gga,
	}
}

func TestGateGeometryArray1D_CreateAndClose(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	if cfg.gga == nil {
		t.Fatal("Create returned nil")
	}
	if err := cfg.gga.Close(); err != nil {
		t.Fatalf("Close error: %v", err)
	}
	// Double close
	if err := cfg.gga.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestGateGeometryArray1D_AppendCentralGate(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	// Use the same gates as in the config
	conns := []*connection.Handle{}
	for i := 0; i < 7; i++ {
		c, _ := cfg.linear.At(uint64(i))
		conns = append(conns, c)
	}
	if err := cfg.gga.AppendCentralGate(conns[2], conns[3], conns[4]); err != nil {
		t.Fatalf("AppendCentralGate error: %v", err)
	}
}

func TestGateGeometryArray1D_AllDotGates(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.AllDotGates()
	if err != nil {
		t.Fatalf("AllDotGates error: %v", err)
	}
	if res == nil {
		t.Error("AllDotGates returned nil")
	}
}

func TestGateGeometryArray1D_QueryNeighbors(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	// Use plunger gate "P1" as in the C++ test
	p1, err := connection.NewPlungerGate("P1")
	if err != nil {
		t.Fatalf("NewPlungerGate(P1): %v", err)
	}
	res, err := cfg.gga.QueryNeighbors(p1)
	if err != nil {
		t.Fatalf("QueryNeighbors error: %v", err)
	}
	if res == nil {
		t.Error("QueryNeighbors returned nil")
	}
}

func TestGateGeometryArray1D_LeftReservoir(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.LeftReservoir()
	if err != nil {
		t.Fatalf("LeftReservoir error: %v", err)
	}
	if res == nil {
		t.Error("LeftReservoir returned nil")
	}
}

func TestGateGeometryArray1D_RightReservoir(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.RightReservoir()
	if err != nil {
		t.Fatalf("RightReservoir error: %v", err)
	}
	if res == nil {
		t.Error("RightReservoir returned nil")
	}
}

func TestGateGeometryArray1D_LeftBarrier(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.LeftBarrier()
	if err != nil {
		t.Fatalf("LeftBarrier error: %v", err)
	}
	if res == nil {
		t.Error("LeftBarrier returned nil")
	}
}

func TestGateGeometryArray1D_RightBarrier(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.RightBarrier()
	if err != nil {
		t.Fatalf("RightBarrier error: %v", err)
	}
	if res == nil {
		t.Error("RightBarrier returned nil")
	}
}

func TestGateGeometryArray1D_LinearArray(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.LinearArray()
	if err != nil {
		t.Fatalf("LinearArray error: %v", err)
	}
	if res == nil {
		t.Error("LinearArray returned nil")
	}
}

func TestGateGeometryArray1D_ScreeningGates(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.ScreeningGates()
	if err != nil {
		t.Fatalf("ScreeningGates error: %v", err)
	}
	if res == nil {
		t.Error("ScreeningGates returned nil")
	}
}

func TestGateGeometryArray1D_RawCentralGates(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.RawCentralGates()
	if err != nil {
		t.Fatalf("RawCentralGates error: %v", err)
	}
	if res == nil {
		t.Error("RawCentralGates returned nil")
	}
}

func TestGateGeometryArray1D_CentralDotGates(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.CentralDotGates()
	if err != nil {
		t.Fatalf("CentralDotGates error: %v", err)
	}
	if res == nil {
		t.Error("CentralDotGates returned nil")
	}
}

func TestGateGeometryArray1D_Ohmics(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	res, err := cfg.gga.Ohmics()
	if err != nil {
		t.Fatalf("Ohmics error: %v", err)
	}
	if res == nil {
		t.Error("Ohmics returned nil")
	}
}

func TestGateGeometryArray1D_EqualAndNotEqual(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	cfg2 := setupGateGeometryArray1D(t)
	defer cfg2.gga.Close()
	defer cfg2.linear.Close()
	defer cfg2.screening.Close()
	eq, err := cfg.gga.Equal(cfg2.gga)
	if err != nil {
		t.Fatalf("Equal error: %v", err)
	}
	if !eq {
		t.Error("Equal = false, want true")
	}
	neq, err := cfg.gga.NotEqual(cfg2.gga)
	if err != nil {
		t.Fatalf("NotEqual error: %v", err)
	}
	if neq {
		t.Error("NotEqual = true, want false")
	}
}

func TestGateGeometryArray1D_ToJSONAndFromJSON(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	defer cfg.gga.Close()
	defer cfg.linear.Close()
	defer cfg.screening.Close()
	jsonStr, err := cfg.gga.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON error: %v", err)
	}
	gga2, err := FromJSON(jsonStr)
	if err != nil {
		t.Fatalf("FromJSON error: %v", err)
	}
	defer gga2.Close()
	eq, err := cfg.gga.Equal(gga2)
	if err != nil || !eq {
		t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
	}
}

func TestGateGeometryArray1D_ClosedErrors(t *testing.T) {
	cfg := setupGateGeometryArray1D(t)
	conns := []*connection.Handle{}
	for i := 0; i < 7; i++ {
		c, _ := cfg.linear.At(uint64(i))
		conns = append(conns, c)
	}
	cfg.gga.Close()
	cfg.linear.Close()
	cfg.screening.Close()
	if _, err := cfg.gga.AllDotGates(); err == nil {
		t.Error("AllDotGates() on closed: expected error")
	}
	if _, err := cfg.gga.QueryNeighbors(conns[3]); err == nil {
		t.Error("QueryNeighbors() on closed: expected error")
	}
	if _, err := cfg.gga.LeftReservoir(); err == nil {
		t.Error("LeftReservoir() on closed: expected error")
	}
	if _, err := cfg.gga.RightReservoir(); err == nil {
		t.Error("RightReservoir() on closed: expected error")
	}
	if _, err := cfg.gga.LeftBarrier(); err == nil {
		t.Error("LeftBarrier() on closed: expected error")
	}
	if _, err := cfg.gga.RightBarrier(); err == nil {
		t.Error("RightBarrier() on closed: expected error")
	}
	if _, err := cfg.gga.LinearArray(); err == nil {
		t.Error("LinearArray() on closed: expected error")
	}
	if _, err := cfg.gga.ScreeningGates(); err == nil {
		t.Error("ScreeningGates() on closed: expected error")
	}
	if _, err := cfg.gga.RawCentralGates(); err == nil {
		t.Error("RawCentralGates() on closed: expected error")
	}
	if _, err := cfg.gga.CentralDotGates(); err == nil {
		t.Error("CentralDotGates() on closed: expected error")
	}
	if _, err := cfg.gga.Ohmics(); err == nil {
		t.Error("Ohmics() on closed: expected error")
	}
	if _, err := cfg.gga.Equal(cfg.gga); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := cfg.gga.NotEqual(cfg.gga); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
	if _, err := cfg.gga.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := cfg.gga.AppendCentralGate(conns[2], conns[3], conns[4]); err == nil {
		t.Error("AppendCentralGate() on closed: expected error")
	}
	if err := cfg.gga.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}
