package group

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

type testGroupConfig struct {
	channel   *channel.Handle
	numDots   int32
	screening *connections.Handle
	reservoir *connections.Handle
	plunger   *connections.Handle
	barrier   *connections.Handle
	order     *connections.Handle
	group     *Handle
}

func setupGroup(t *testing.T) *testGroupConfig {
	t.Helper()
	ch, err := channel.New("test")
	if err != nil {
		t.Fatalf("channel.New error: %v", err)
	}
	numDots := int32(2)

	s1, _ := connection.NewScreeningGate("s1")
	s2, _ := connection.NewScreeningGate("s2")
	screening, err := connections.New([]*connection.Handle{s1, s2})
	if err != nil {
		t.Fatalf("connections.New(screening): %v", err)
	}

	r1, _ := connection.NewReservoirGate("R1")
	r2, _ := connection.NewReservoirGate("R2")
	reservoir, err := connections.New([]*connection.Handle{r1, r2})
	if err != nil {
		t.Fatalf("connections.New(reservoir): %v", err)
	}

	p1, _ := connection.NewPlungerGate("P1")
	plunger, err := connections.New([]*connection.Handle{p1})
	if err != nil {
		t.Fatalf("connections.New(plunger): %v", err)
	}

	b1, _ := connection.NewBarrierGate("B1")
	b2, _ := connection.NewBarrierGate("B2")
	barrier, err := connections.New([]*connection.Handle{b1, b2})
	if err != nil {
		t.Fatalf("connections.New(barrier): %v", err)
	}

	o1, _ := connection.NewOhmic("O1")
	o2, _ := connection.NewOhmic("O2")
	orderList := []*connection.Handle{o1, r1, b1, p1, b2, r2, o2}
	order, err := connections.New(orderList)
	if err != nil {
		t.Fatalf("connections.New(order): %v", err)
	}

	group, err := New(ch, numDots, screening, reservoir, plunger, barrier, order)
	if err != nil {
		t.Fatalf("Create group error: %v", err)
	}

	return &testGroupConfig{
		channel:   ch,
		numDots:   numDots,
		screening: screening,
		reservoir: reservoir,
		plunger:   plunger,
		barrier:   barrier,
		order:     order,
		group:     group,
	}
}

func teardownGroup(cfg *testGroupConfig) {
	cfg.group.Close()
	cfg.channel.Close()
	cfg.screening.Close()
	cfg.reservoir.Close()
	cfg.plunger.Close()
	cfg.barrier.Close()
	cfg.order.Close()
}

func TestGroup_NameAndNumDots(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	name, err := cfg.group.Name()
	if err != nil {
		t.Fatalf("Name error: %v", err)
	}
	n, err := name.Name()
	if err != nil {
		t.Fatalf("ChannelName error: %v", err)
	}
	if n != "test" {
		t.Errorf("Channel name = %q, want %q", n, "test")
	}
	numDots, err := cfg.group.NumDots()
	if err != nil {
		t.Fatalf("NumDots error: %v", err)
	}
	if numDots != cfg.numDots {
		t.Errorf("NumDots = %v, want %v", numDots, cfg.numDots)
	}
	name.Close()
}

func TestGroup_ScreeningGatesGetter(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	gates, err := cfg.group.ScreeningGates()
	if err != nil {
		t.Fatalf("ScreeningGates error: %v", err)
	}
	sz, _ := gates.Size()
	if sz != 2 {
		t.Errorf("ScreeningGates size = %v, want 2", sz)
	}
	gates.Close()
}

func TestGroup_ReservoirGatesGetter(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	gates, err := cfg.group.ReservoirGates()
	if err != nil {
		t.Fatalf("ReservoirGates error: %v", err)
	}
	sz, _ := gates.Size()
	if sz != 2 {
		t.Errorf("ReservoirGates size = %v, want 2", sz)
	}
	gates.Close()
}

func TestGroup_PlungerGatesGetter(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	gates, err := cfg.group.PlungerGates()
	if err != nil {
		t.Fatalf("PlungerGates error: %v", err)
	}
	sz, _ := gates.Size()
	if sz != 1 {
		t.Errorf("PlungerGates size = %v, want 1", sz)
	}
	gates.Close()
}

func TestGroup_BarrierGatesGetter(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	gates, err := cfg.group.BarrierGates()
	if err != nil {
		t.Fatalf("BarrierGates error: %v", err)
	}
	sz, _ := gates.Size()
	if sz != 2 {
		t.Errorf("BarrierGates size = %v, want 2", sz)
	}
	gates.Close()
}

func TestGroup_OrderGetter(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	order, err := cfg.group.Order()
	if err != nil {
		t.Fatalf("Order error: %v", err)
	}
	if order == nil {
		t.Error("Order returned nil")
	}
	order.Close()
}

func TestGroup_OhmicsGetter(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	ohmics, err := cfg.group.Ohmics()
	if err != nil {
		t.Fatalf("Ohmics error: %v", err)
	}
	sz, _ := ohmics.Size()
	if sz != 2 {
		t.Errorf("Ohmics size = %v, want 2", sz)
	}
	ohmics.Close()
}

func TestGroup_GetOhmic(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	ohmic, err := cfg.group.GetOhmic()
	if err != nil {
		t.Fatalf("GetOhmic error: %v", err)
	}
	n, _ := ohmic.Name()
	if n != "O1" {
		t.Errorf("GetOhmic name = %q, want %q", n, "O1")
	}
	ohmic.Close()
}

func TestGroup_GetPlunger(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	plunger, err := cfg.group.GetPlungerGate()
	if err != nil {
		t.Fatalf("GetPlungerGate error: %v", err)
	}
	n, _ := plunger.Name()
	if n != "P1" {
		t.Errorf("GetPlungerGate name = %q, want %q", n, "P1")
	}
	plunger.Close()
}

func TestGroup_GetReservoir(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	reservoir, err := cfg.group.GetReservoirGate()
	if err != nil {
		t.Fatalf("GetReservoirGate error: %v", err)
	}
	n, _ := reservoir.Name()
	if n != "R1" {
		t.Errorf("GetReservoirGate name = %q, want %q", n, "R1")
	}
	reservoir.Close()
}

func TestGroup_GetBarrier(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	barrier, err := cfg.group.GetBarrierGate()
	if err != nil {
		t.Fatalf("GetBarrierGate error: %v", err)
	}
	n, _ := barrier.Name()
	if n != "B1" {
		t.Errorf("GetBarrierGate name = %q, want %q", n, "B1")
	}
	barrier.Close()
}

func TestGroup_GetScreening(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	screening, err := cfg.group.GetScreeningGate()
	if err != nil {
		t.Fatalf("GetScreeningGate error: %v", err)
	}
	n, _ := screening.Name()
	if n != "s1" {
		t.Errorf("GetScreeningGate name = %q, want %q", n, "s1")
	}
	screening.Close()
}

func TestGroup_GetDot(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	dot, err := cfg.group.GetDotGate()
	if err != nil {
		t.Fatalf("GetDotGate error: %v", err)
	}
	n, _ := dot.Name()
	if n != "P1" {
		t.Errorf("GetDotGate name = %q, want %q", n, "P1")
	}
	dot.Close()
}

func TestGroup_GetGate(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	gate, err := cfg.group.GetGate()
	if err != nil {
		t.Fatalf("GetGate error: %v", err)
	}
	n, _ := gate.Name()
	if n != "P1" {
		t.Errorf("GetGate name = %q, want %q", n, "P1")
	}
	gate.Close()
}

func TestGroup_GetAllGates(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	gates, err := cfg.group.GetAllGates()
	if err != nil {
		t.Fatalf("GetAllGates error: %v", err)
	}
	sz, _ := gates.Size()
	if sz != 7 {
		t.Errorf("GetAllGates size = %v, want 7", sz)
	}
	gates.Close()
}

func TestGroup_GetAllConnections(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	conns, err := cfg.group.GetAllConnections()
	if err != nil {
		t.Fatalf("GetAllConnections error: %v", err)
	}
	sz, _ := conns.Size()
	if sz != 9 {
		t.Errorf("GetAllConnections size = %v, want 9", sz)
	}
	conns.Close()
}

func TestGroup_HasOhmic(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	ohmic, _ := connection.NewOhmic("O1")
	defer ohmic.Close()
	ok, err := cfg.group.HasOhmic(ohmic)
	if err != nil {
		t.Fatalf("HasOhmic error: %v", err)
	}
	if !ok {
		t.Error("HasOhmic = false, want true")
	}
}

func TestGroup_HasGate(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	b2, _ := connection.NewBarrierGate("B2")
	defer b2.Close()
	ok, err := cfg.group.HasGate(b2)
	if err != nil {
		t.Fatalf("HasGate error: %v", err)
	}
	if !ok {
		t.Error("HasGate = false, want true")
	}
}

func TestGroup_HasBarrierGate(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	b1, _ := connection.NewBarrierGate("B1")
	defer b1.Close()
	ok, err := cfg.group.HasBarrierGate(b1)
	if err != nil {
		t.Fatalf("HasBarrierGate error: %v", err)
	}
	if !ok {
		t.Error("HasBarrierGate = false, want true")
	}
}

func TestGroup_HasPlungerGate(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	p1, _ := connection.NewPlungerGate("P1")
	defer p1.Close()
	ok, err := cfg.group.HasPlungerGate(p1)
	if err != nil {
		t.Fatalf("HasPlungerGate error: %v", err)
	}
	if !ok {
		t.Error("HasPlungerGate = false, want true")
	}
}

func TestGroup_HasReservoirGate(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	r2, _ := connection.NewReservoirGate("R2")
	defer r2.Close()
	ok, err := cfg.group.HasReservoirGate(r2)
	if err != nil {
		t.Fatalf("HasReservoirGate error: %v", err)
	}
	if !ok {
		t.Error("HasReservoirGate = false, want true")
	}
}

func TestGroup_HasScreeningGate(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	s2, _ := connection.NewScreeningGate("s2")
	defer s2.Close()
	ok, err := cfg.group.HasScreeningGate(s2)
	if err != nil {
		t.Fatalf("HasScreeningGate error: %v", err)
	}
	if !ok {
		t.Error("HasScreeningGate = false, want true")
	}
}

func TestGroup_DotGatesGetter(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	dots, err := cfg.group.DotGates()
	if err != nil {
		t.Fatalf("DotGates error: %v", err)
	}
	sz, _ := dots.Size()
	if sz != 3 {
		t.Errorf("DotGates size = %v, want 3", sz)
	}
	dots.Close()
}

func TestGroup_HasChannel(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	ok, err := cfg.group.HasChannel(cfg.channel)
	if err != nil {
		t.Fatalf("HasChannel error: %v", err)
	}
	if !ok {
		t.Error("HasChannel = false, want true")
	}
	other, _ := channel.New("other")
	defer other.Close()
	ok, err = cfg.group.HasChannel(other)
	if err != nil {
		t.Fatalf("HasChannel(other) error: %v", err)
	}
	if ok {
		t.Error("HasChannel(other) = true, want false")
	}
}

func TestGroup_IsChargeSensor(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	ok, err := cfg.group.IsChargeSensor()
	if err != nil {
		t.Fatalf("IsChargeSensor error: %v", err)
	}
	if ok {
		t.Error("IsChargeSensor = true, want false")
	}
	// Now test with numDots = 1
	group2, err := New(cfg.channel, 1, cfg.screening, cfg.reservoir, cfg.plunger, cfg.barrier, cfg.order)
	if err != nil {
		t.Fatalf("Create group2 error: %v", err)
	}
	defer group2.Close()
	ok, err = group2.IsChargeSensor()
	if err != nil {
		t.Fatalf("IsChargeSensor (group2) error: %v", err)
	}
	if !ok {
		t.Error("IsChargeSensor (group2) = false, want true")
	}
}

func TestGroup_GetAllChannelGates(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	gates, err := cfg.group.GetAllChannelGates()
	if err != nil {
		t.Fatalf("GetAllChannelGates error: %v", err)
	}
	sz, _ := gates.Size()
	if sz == 0 {
		t.Error("GetAllChannelGates size = 0, want > 0")
	}
	gates.Close()
}

func TestGroup_SerializationRoundTrip(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	jsonStr, err := cfg.group.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON error: %v", err)
	}
	group2, err := FromJSON(jsonStr)
	if err != nil {
		t.Fatalf("FromJSON error: %v", err)
	}
	defer group2.Close()
	eq, err := cfg.group.Equal(group2)
	if err != nil || !eq {
		t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
	}
}

func TestGroup_EqualityAndInequality(t *testing.T) {
	cfg := setupGroup(t)
	defer teardownGroup(cfg)
	group2, err := New(cfg.channel, cfg.numDots, cfg.screening, cfg.reservoir, cfg.plunger, cfg.barrier, cfg.order)
	if err != nil {
		t.Fatalf("Create group2 error: %v", err)
	}
	defer group2.Close()
	eq, err := cfg.group.Equal(group2)
	if err != nil || !eq {
		t.Errorf("Equal = %v, want true, err: %v", eq, err)
	}
	neq, err := cfg.group.NotEqual(group2)
	if err != nil {
		t.Fatalf("NotEqual error: %v", err)
	}
	if neq {
		t.Error("NotEqual = true, want false")
	}
}

func TestGroup_ClosedErrors(t *testing.T) {
	cfg := setupGroup(t)
	teardownGroup(cfg)
	// All methods should error on closed handle
	if _, err := cfg.group.Name(); err == nil {
		t.Error("Name() on closed: expected error")
	}
	if _, err := cfg.group.NumDots(); err == nil {
		t.Error("NumDots() on closed: expected error")
	}
	if _, err := cfg.group.Order(); err == nil {
		t.Error("Order() on closed: expected error")
	}
	if _, err := cfg.group.HasChannel(cfg.channel); err == nil {
		t.Error("HasChannel() on closed: expected error")
	}
	if _, err := cfg.group.IsChargeSensor(); err == nil {
		t.Error("IsChargeSensor() on closed: expected error")
	}
	if _, err := cfg.group.GetAllChannelGates(); err == nil {
		t.Error("GetAllChannelGates() on closed: expected error")
	}
	if _, err := cfg.group.ScreeningGates(); err == nil {
		t.Error("ScreeningGates() on closed: expected error")
	}
	if _, err := cfg.group.ReservoirGates(); err == nil {
		t.Error("ReservoirGates() on closed: expected error")
	}
	if _, err := cfg.group.PlungerGates(); err == nil {
		t.Error("PlungerGates() on closed: expected error")
	}
	if _, err := cfg.group.BarrierGates(); err == nil {
		t.Error("BarrierGates() on closed: expected error")
	}
	if _, err := cfg.group.Ohmics(); err == nil {
		t.Error("Ohmics() on closed: expected error")
	}
	if _, err := cfg.group.DotGates(); err == nil {
		t.Error("DotGates() on closed: expected error")
	}
	if _, err := cfg.group.GetOhmic(); err == nil {
		t.Error("GetOhmic() on closed: expected error")
	}
	if _, err := cfg.group.GetBarrierGate(); err == nil {
		t.Error("GetBarrierGate() on closed: expected error")
	}
	if _, err := cfg.group.GetPlungerGate(); err == nil {
		t.Error("GetPlungerGate() on closed: expected error")
	}
	if _, err := cfg.group.GetReservoirGate(); err == nil {
		t.Error("GetReservoirGate() on closed: expected error")
	}
	if _, err := cfg.group.GetScreeningGate(); err == nil {
		t.Error("GetScreeningGate() on closed: expected error")
	}
	if _, err := cfg.group.GetDotGate(); err == nil {
		t.Error("GetDotGate() on closed: expected error")
	}
	if _, err := cfg.group.GetGate(); err == nil {
		t.Error("GetGate() on closed: expected error")
	}
	if _, err := cfg.group.GetAllGates(); err == nil {
		t.Error("GetAllGates() on closed: expected error")
	}
	if _, err := cfg.group.GetAllConnections(); err == nil {
		t.Error("GetAllConnections() on closed: expected error")
	}
	firstscreening, err := cfg.screening.At(0)
	if err == nil {
		t.Error("cfg.screening.At(0) on closed: expected error")
	}
	firstbarrier, err := cfg.barrier.At(0)
	if err == nil {
		t.Error("cfg.barrier.At(0) on closed: expected error")
	}
	firstplunger, err := cfg.plunger.At(0)
	if err == nil {
		t.Error("cfg.plunger.At(0) on closed: expected error")
	}
	firstreservoir, err := cfg.reservoir.At(0)
	if err == nil {
		t.Error("cfg.reservoir.At(0) on closed: expected error")
	}
	if _, err := cfg.group.HasOhmic(firstscreening); err == nil {
		t.Error("HasOhmic() on closed: expected error")
	}
	if _, err := cfg.group.HasGate(firstscreening); err == nil {
		t.Error("HasGate() on closed: expected error")
	}
	if _, err := cfg.group.HasBarrierGate(firstbarrier); err == nil {
		t.Error("HasBarrierGate() on closed: expected error")
	}
	if _, err := cfg.group.HasPlungerGate(firstplunger); err == nil {
		t.Error("HasPlungerGate() on closed: expected error")
	}
	if _, err := cfg.group.HasReservoirGate(firstreservoir); err == nil {
		t.Error("HasReservoirGate() on closed: expected error")
	}
	if _, err := cfg.group.HasScreeningGate(firstscreening); err == nil {
		t.Error("HasScreeningGate() on closed: expected error")
	}
	if _, err := cfg.group.Equal(cfg.group); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := cfg.group.NotEqual(cfg.group); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
	if _, err := cfg.group.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
}
