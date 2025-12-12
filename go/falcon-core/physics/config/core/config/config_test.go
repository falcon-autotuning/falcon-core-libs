package config

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/gname"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapgnamegroup"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairdoubledouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/adjacency"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/group"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/voltageconstraints"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/impedance"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/impedances"
)

func makeFixtureImpedances(t *testing.T) *impedances.Handle {
	imp, err := impedances.NewEmpty()
	if err != nil {
		t.Fatalf("impedances.NewEmpty: %v", err)
	}
	// Add all the impedances as in the C++ setup
	add := func(conn *connection.Handle, val, tol float64) {
		impH, err := impedance.New(conn, val, tol)
		if err != nil {
			t.Fatalf("impedance.New: %v", err)
		}
		if err := imp.PushBack(impH); err != nil {
			t.Fatalf("imp.PushBack: %v", err)
		}
	}
	o1, _ := connection.NewOhmic("O1")
	o2, _ := connection.NewOhmic("O2")
	b1, _ := connection.NewBarrierGate("B1")
	b2, _ := connection.NewBarrierGate("B2")
	b3, _ := connection.NewBarrierGate("B3")
	p1, _ := connection.NewPlungerGate("P1")
	p2, _ := connection.NewPlungerGate("P2")
	r1, _ := connection.NewReservoirGate("R1")
	r2, _ := connection.NewReservoirGate("R2")
	sg1, _ := connection.NewScreeningGate("SG1")
	sg2, _ := connection.NewScreeningGate("SG2")

	add(o1, 1000.0, 1e-12)
	add(o2, 1000.0, 1e-12)
	add(b1, 10000.0, 1e-12)
	add(b2, 10000.0, 1e-12)
	add(b3, 10000.0, 1e-12)
	add(p1, 10000.0, 1e-12)
	add(p2, 10000.0, 1e-12)
	add(r1, 10000.0, 1e-12)
	add(r2, 10000.0, 1e-12)
	add(sg1, 10000.0, 1e-12)
	add(sg2, 10000.0, 1e-12)

	return imp
}

func makeFixtureVoltageConstraints(t *testing.T) *voltageconstraints.Handle {
	adjIndexes, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty for adjacency indexes: %v", err)
	}
	sg1, _ := connection.NewScreeningGate("SG1")
	sg2, _ := connection.NewScreeningGate("SG2")
	p1, _ := connection.NewPlungerGate("P1")
	p2, _ := connection.NewPlungerGate("P2")
	b1, _ := connection.NewBarrierGate("B1")
	b2, _ := connection.NewBarrierGate("B2")
	b3, _ := connection.NewBarrierGate("B3")
	r1, _ := connection.NewReservoirGate("R1")
	r2, _ := connection.NewReservoirGate("R2")
	for _, c := range []*connection.Handle{sg1, sg2, p1, p2, b1, b2, b3, r1, r2} {
		if err := adjIndexes.PushBack(c); err != nil {
			t.Fatalf("adjIndexes.PushBack: %v", err)
		}
	}
	adjData := make([]int32, 81)
	for i := 0; i < 81; i++ {
		if i%10 == 0 {
			adjData[i] = 1
		}
	}
	adjShape := []uint64{9, 9}
	adj, err := adjacency.New(adjData, adjShape, adjIndexes)
	if err != nil {
		t.Fatalf("adjacency.New: %v", err)
	}
	bounds, err := pairdoubledouble.New(-1.0, 1.0)
	if err != nil {
		t.Fatalf("pairdoubledouble.New: %v", err)
	}
	vc, err := voltageconstraints.New(adj, 1.0, bounds)
	if err != nil {
		t.Fatalf("voltageconstraints.New: %v", err)
	}
	return vc
}

func makeFixtureConfig(t *testing.T) *Handle {
	// Screening gates
	screening, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty screening: %v", err)
	}
	sg1, err := connection.NewScreeningGate("SG1")
	if err != nil {
		t.Fatalf("NewScreeningGate SG1: %v", err)
	}
	sg2, err := connection.NewScreeningGate("SG2")
	if err != nil {
		t.Fatalf("NewScreeningGate SG2: %v", err)
	}
	if err := screening.PushBack(sg1); err != nil {
		t.Fatalf("screening.PushBack SG1: %v", err)
	}
	if err := screening.PushBack(sg2); err != nil {
		t.Fatalf("screening.PushBack SG2: %v", err)
	}

	// Plunger gates
	plunger, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty plunger: %v", err)
	}
	p1, err := connection.NewPlungerGate("P1")
	if err != nil {
		t.Fatalf("NewPlungerGate P1: %v", err)
	}
	p2, err := connection.NewPlungerGate("P2")
	if err != nil {
		t.Fatalf("NewPlungerGate P2: %v", err)
	}
	if err := plunger.PushBack(p1); err != nil {
		t.Fatalf("plunger.PushBack P1: %v", err)
	}
	if err := plunger.PushBack(p2); err != nil {
		t.Fatalf("plunger.PushBack P2: %v", err)
	}

	// Ohmics
	ohmics, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty ohmics: %v", err)
	}
	o1, err := connection.NewOhmic("O1")
	if err != nil {
		t.Fatalf("NewOhmic O1: %v", err)
	}
	o2, err := connection.NewOhmic("O2")
	if err != nil {
		t.Fatalf("NewOhmic O2: %v", err)
	}
	if err := ohmics.PushBack(o1); err != nil {
		t.Fatalf("ohmics.PushBack O1: %v", err)
	}
	if err := ohmics.PushBack(o2); err != nil {
		t.Fatalf("ohmics.PushBack O2: %v", err)
	}

	// Barrier gates
	barrier, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty barrier: %v", err)
	}
	b1, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf("NewBarrierGate B1: %v", err)
	}
	b2, err := connection.NewBarrierGate("B2")
	if err != nil {
		t.Fatalf("NewBarrierGate B2: %v", err)
	}
	b3, err := connection.NewBarrierGate("B3")
	if err != nil {
		t.Fatalf("NewBarrierGate B3: %v", err)
	}
	if err := barrier.PushBack(b1); err != nil {
		t.Fatalf("barrier.PushBack B1: %v", err)
	}
	if err := barrier.PushBack(b2); err != nil {
		t.Fatalf("barrier.PushBack B2: %v", err)
	}
	if err := barrier.PushBack(b3); err != nil {
		t.Fatalf("barrier.PushBack B3: %v", err)
	}

	// Reservoir gates
	reservoir, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty reservoir: %v", err)
	}
	r1, err := connection.NewReservoirGate("R1")
	if err != nil {
		t.Fatalf("NewReservoirGate R1: %v", err)
	}
	r2, err := connection.NewReservoirGate("R2")
	if err != nil {
		t.Fatalf("NewReservoirGate R2: %v", err)
	}
	if err := reservoir.PushBack(r1); err != nil {
		t.Fatalf("reservoir.PushBack R1: %v", err)
	}
	if err := reservoir.PushBack(r2); err != nil {
		t.Fatalf("reservoir.PushBack R2: %v", err)
	}

	// Group and map
	ch, err := channel.New("CH1")
	if err != nil {
		t.Fatalf("channel.New CH1: %v", err)
	}
	groupScreening, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty groupScreening: %v", err)
	}
	if err := groupScreening.PushBack(sg1); err != nil {
		t.Fatalf("groupScreening.PushBack SG1: %v", err)
	}
	if err := groupScreening.PushBack(sg2); err != nil {
		t.Fatalf("groupScreening.PushBack SG2: %v", err)
	}
	groupReservoir, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty groupReservoir: %v", err)
	}
	if err := groupReservoir.PushBack(r1); err != nil {
		t.Fatalf("groupReservoir.PushBack R1: %v", err)
	}
	if err := groupReservoir.PushBack(r2); err != nil {
		t.Fatalf("groupReservoir.PushBack R2: %v", err)
	}
	groupPlunger, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty groupPlunger: %v", err)
	}
	if err := groupPlunger.PushBack(p1); err != nil {
		t.Fatalf("groupPlunger.PushBack P1: %v", err)
	}
	if err := groupPlunger.PushBack(p2); err != nil {
		t.Fatalf("groupPlunger.PushBack P2: %v", err)
	}
	groupBarrier, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty groupBarrier: %v", err)
	}
	if err := groupBarrier.PushBack(b1); err != nil {
		t.Fatalf("groupBarrier.PushBack B1: %v", err)
	}
	if err := groupBarrier.PushBack(b2); err != nil {
		t.Fatalf("groupBarrier.PushBack B2: %v", err)
	}
	if err := groupBarrier.PushBack(b3); err != nil {
		t.Fatalf("groupBarrier.PushBack B3: %v", err)
	}
	groupOrder, err := connections.NewEmpty()
	if err != nil {
		t.Fatalf("connections.NewEmpty groupOrder: %v", err)
	}
	if err := groupOrder.PushBack(o1); err != nil {
		t.Fatalf("groupOrder.PushBack O1: %v", err)
	}
	if err := groupOrder.PushBack(r1); err != nil {
		t.Fatalf("groupOrder.PushBack R1: %v", err)
	}
	if err := groupOrder.PushBack(b1); err != nil {
		t.Fatalf("groupOrder.PushBack B1: %v", err)
	}
	if err := groupOrder.PushBack(p1); err != nil {
		t.Fatalf("groupOrder.PushBack P1: %v", err)
	}
	if err := groupOrder.PushBack(b2); err != nil {
		t.Fatalf("groupOrder.PushBack B2: %v", err)
	}
	if err := groupOrder.PushBack(p2); err != nil {
		t.Fatalf("groupOrder.PushBack P2: %v", err)
	}
	if err := groupOrder.PushBack(b3); err != nil {
		t.Fatalf("groupOrder.PushBack B3: %v", err)
	}
	if err := groupOrder.PushBack(r2); err != nil {
		t.Fatalf("groupOrder.PushBack R2: %v", err)
	}
	if err := groupOrder.PushBack(o2); err != nil {
		t.Fatalf("groupOrder.PushBack O2: %v", err)
	}
	groupH, err := group.New(ch, 2, groupScreening, groupReservoir, groupPlunger, groupBarrier, groupOrder)
	if err != nil {
		t.Fatalf("group.New: %v", err)
	}
	gnameH, err := gname.New("group1")
	if err != nil {
		t.Fatalf("gname.New: %v", err)
	}
	groups, err := mapgnamegroup.NewEmpty()
	if err != nil {
		t.Fatalf("mapgnamegroup.NewEmpty: %v", err)
	}
	if err := groups.Insert(gnameH, groupH); err != nil {
		t.Fatalf("groups.Insert: %v", err)
	}

	// Impedances
	imp := makeFixtureImpedances(t)
	vc := makeFixtureVoltageConstraints(t)

	cfg, err := New(screening, plunger, ohmics, barrier, reservoir, groups, imp, vc)
	if err != nil {
		t.Fatalf("Config.New failed: %v", err)
	}
	return cfg
}

func TestConfig_AllMethods(t *testing.T) {
	cfg := makeFixtureConfig(t)
	defer cfg.Close()

	ch, err := channel.New("CH1")
	if err != nil {
		t.Fatalf("channel.New: %v", err)
	}
	gn, err := gname.New("group1")
	if err != nil {
		t.Fatalf("gname.New: %v", err)
	}
	gate, err := connection.NewBarrierGate("B1")
	if err != nil {
		t.Fatalf("NewBarrierGate: %v", err)
	}
	ohmic, err := connection.NewOhmic("O1")
	if err != nil {
		t.Fatalf("NewOhmic: %v", err)
	}
	reservoir, err := connection.NewReservoirGate("R1")
	if err != nil {
		t.Fatalf("NewReservoirGate: %v", err)
	}
	screeningConn, err := connection.NewScreeningGate("SG1")
	if err != nil {
		t.Fatalf("NewScreeningGate: %v", err)
	}
	plungerConn, err := connection.NewPlungerGate("P1")
	if err != nil {
		t.Fatalf("NewPlungerGate: %v", err)
	}

	// Accessors and outputs
	if _, err := cfg.VoltageConstraints(); err != nil {
		t.Errorf("VoltageConstraints() failed: %v", err)
	}
	if _, err := cfg.Groups(); err != nil {
		t.Errorf("Groups() failed: %v", err)
	}
	if _, err := cfg.WiringDc(); err != nil {
		t.Errorf("WiringDc() failed: %v", err)
	}
	if _, err := cfg.Channels(); err != nil {
		t.Errorf("Channels() failed: %v", err)
	}
	if _, err := cfg.GetImpedance(ohmic); err != nil {
		t.Errorf("GetImpedance() failed: %v", err)
	}
	if _, err := cfg.GetAllGnames(); err != nil {
		t.Errorf("GetAllGnames() failed: %v", err)
	}
	if _, err := cfg.GetAllGroups(); err != nil {
		t.Errorf("GetAllGroups() failed: %v", err)
	}
	if _, err := cfg.HasChannel(ch); err != nil {
		t.Errorf("HasChannel() failed: %v", err)
	}
	if _, err := cfg.HasGname(gn); err != nil {
		t.Errorf("HasGname() failed: %v", err)
	}
	if _, err := cfg.SelectGroup(gn); err != nil {
		t.Errorf("SelectGroup() failed: %v", err)
	}
	if _, err := cfg.GetDotNumber(ch); err != nil {
		t.Errorf("GetDotNumber() failed: %v", err)
	}
	if _, err := cfg.GetChargeSenseGroups(); err != nil {
		t.Errorf("GetChargeSenseGroups() failed: %v", err)
	}
	if _, err := cfg.OhmicInChargeSensor(ohmic); err != nil {
		t.Errorf("OhmicInChargeSensor() failed: %v", err)
	}
	if _, err := cfg.GetAssociatedOhmic(reservoir); err != nil {
		t.Errorf("GetAssociatedOhmic() failed: %v", err)
	}
	if _, err := cfg.GetCurrentChannels(); err != nil {
		t.Errorf("GetCurrentChannels() failed: %v", err)
	}
	if _, err := cfg.GetGname(ch); err != nil {
		t.Errorf("GetGname() failed: %v", err)
	}
	if _, err := cfg.GetGroupBarrierGates(gn); err != nil {
		t.Errorf("GetGroupBarrierGates() failed: %v", err)
	}
	if _, err := cfg.GetGroupPlungerGates(gn); err != nil {
		t.Errorf("GetGroupPlungerGates() failed: %v", err)
	}
	if _, err := cfg.GetGroupReservoirGates(gn); err != nil {
		t.Errorf("GetGroupReservoirGates() failed: %v", err)
	}
	if _, err := cfg.GetGroupScreeningGates(gn); err != nil {
		t.Errorf("GetGroupScreeningGates() failed: %v", err)
	}
	if _, err := cfg.GetGroupDotGates(gn); err != nil {
		t.Errorf("GetGroupDotGates() failed: %v", err)
	}
	if _, err := cfg.GetGroupGates(gn); err != nil {
		t.Errorf("GetGroupGates() failed: %v", err)
	}
	if _, err := cfg.GetChannelBarrierGates(ch); err != nil {
		t.Errorf("GetChannelBarrierGates() failed: %v", err)
	}
	if _, err := cfg.GetChannelPlungerGates(ch); err != nil {
		t.Errorf("GetChannelPlungerGates() failed: %v", err)
	}
	if _, err := cfg.GetChannelReservoirGates(ch); err != nil {
		t.Errorf("GetChannelReservoirGates() failed: %v", err)
	}
	if _, err := cfg.GetChannelScreeningGates(ch); err != nil {
		t.Errorf("GetChannelScreeningGates() failed: %v", err)
	}
	if _, err := cfg.GetChannelDotGates(ch); err != nil {
		t.Errorf("GetChannelDotGates() failed: %v", err)
	}
	if _, err := cfg.GetChannelGates(ch); err != nil {
		t.Errorf("GetChannelGates() failed: %v", err)
	}
	if _, err := cfg.GetChannelOhmics(ch); err != nil {
		t.Errorf("GetChannelOhmics() failed: %v", err)
	}
	if _, err := cfg.GetChannelOrderNoOhmics(ch); err != nil {
		t.Errorf("GetChannelOrderNoOhmics() failed: %v", err)
	}
	if _, err := cfg.GetNumUniqueChannels(); err != nil {
		t.Errorf("GetNumUniqueChannels() failed: %v", err)
	}
	if _, err := cfg.ReturnChannelsFromGate(gate); err != nil {
		t.Errorf("ReturnChannelsFromGate() failed: %v", err)
	}
	if _, err := cfg.ReturnChannelFromGate(gate); err != nil {
		t.Errorf("ReturnChannelFromGate() failed: %v", err)
	}
	if _, err := cfg.OhmicInChannel(ohmic, ch); err != nil {
		t.Errorf("OhmicInChannel() failed: %v", err)
	}
	if _, err := cfg.GetDotChannelNeighbors(gate); err != nil {
		t.Errorf("GetDotChannelNeighbors() failed: %v", err)
	}
	if _, err := cfg.GetBarrierGateDict(); err != nil {
		t.Errorf("GetBarrierGateDict() failed: %v", err)
	}
	if _, err := cfg.GetPlungerGateDict(); err != nil {
		t.Errorf("GetPlungerGateDict() failed: %v", err)
	}
	if _, err := cfg.GetReservoirGateDict(); err != nil {
		t.Errorf("GetReservoirGateDict() failed: %v", err)
	}
	if _, err := cfg.GetScreeningGateDict(); err != nil {
		t.Errorf("GetScreeningGateDict() failed: %v", err)
	}
	if _, err := cfg.GetDotGateDict(); err != nil {
		t.Errorf("GetDotGateDict() failed: %v", err)
	}
	if _, err := cfg.GetGateDict(); err != nil {
		t.Errorf("GetGateDict() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedBarrierGates(); err != nil {
		t.Errorf("GetIsolatedBarrierGates() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedPlungerGates(); err != nil {
		t.Errorf("GetIsolatedPlungerGates() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedReservoirGates(); err != nil {
		t.Errorf("GetIsolatedReservoirGates() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedScreeningGates(); err != nil {
		t.Errorf("GetIsolatedScreeningGates() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedDotGates(); err != nil {
		t.Errorf("GetIsolatedDotGates() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedGates(); err != nil {
		t.Errorf("GetIsolatedGates() failed: %v", err)
	}
	if _, err := cfg.GetSharedBarrierGates(); err != nil {
		t.Errorf("GetSharedBarrierGates() failed: %v", err)
	}
	if _, err := cfg.GetSharedPlungerGates(); err != nil {
		t.Errorf("GetSharedPlungerGates() failed: %v", err)
	}
	if _, err := cfg.GetSharedReservoirGates(); err != nil {
		t.Errorf("GetSharedReservoirGates() failed: %v", err)
	}
	if _, err := cfg.GetSharedScreeningGates(); err != nil {
		t.Errorf("GetSharedScreeningGates() failed: %v", err)
	}
	if _, err := cfg.GetSharedDotGates(); err != nil {
		t.Errorf("GetSharedDotGates() failed: %v", err)
	}
	if _, err := cfg.GetSharedGates(); err != nil {
		t.Errorf("GetSharedGates() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedBarrierGatesByChannel(); err != nil {
		t.Errorf("GetIsolatedBarrierGatesByChannel() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedPlungerGatesByChannel(); err != nil {
		t.Errorf("GetIsolatedPlungerGatesByChannel() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedReservoirGatesByChannel(); err != nil {
		t.Errorf("GetIsolatedReservoirGatesByChannel() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedScreeningGatesByChannel(); err != nil {
		t.Errorf("GetIsolatedScreeningGatesByChannel() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedDotGatesByChannel(); err != nil {
		t.Errorf("GetIsolatedDotGatesByChannel() failed: %v", err)
	}
	if _, err := cfg.GetIsolatedGatesByChannel(); err != nil {
		t.Errorf("GetIsolatedGatesByChannel() failed: %v", err)
	}
	if _, err := cfg.GenerateGateRelations(); err != nil {
		t.Errorf("GenerateGateRelations() failed: %v", err)
	}
	if _, err := cfg.ScreeningGates(); err != nil {
		t.Errorf("ScreeningGates() failed: %v", err)
	}
	if _, err := cfg.ReservoirGates(); err != nil {
		t.Errorf("ReservoirGates() failed: %v", err)
	}
	if _, err := cfg.PlungerGates(); err != nil {
		t.Errorf("PlungerGates() failed: %v", err)
	}
	if _, err := cfg.BarrierGates(); err != nil {
		t.Errorf("BarrierGates() failed: %v", err)
	}
	if _, err := cfg.Ohmics(); err != nil {
		t.Errorf("Ohmics() failed: %v", err)
	}
	if _, err := cfg.DotGates(); err != nil {
		t.Errorf("DotGates() failed: %v", err)
	}
	if _, err := cfg.GetOhmic(); err != nil {
		t.Errorf("GetOhmic() failed: %v", err)
	}
	if _, err := cfg.GetBarrierGate(); err != nil {
		t.Errorf("GetBarrierGate() failed: %v", err)
	}
	if _, err := cfg.GetPlungerGate(); err != nil {
		t.Errorf("GetPlungerGate() failed: %v", err)
	}
	if _, err := cfg.GetReservoirGate(); err != nil {
		t.Errorf("GetReservoirGate() failed: %v", err)
	}
	if _, err := cfg.GetScreeningGate(); err != nil {
		t.Errorf("GetScreeningGate() failed: %v", err)
	}
	if _, err := cfg.GetDotGate(); err != nil {
		t.Errorf("GetDotGate() failed: %v", err)
	}
	if _, err := cfg.GetGate(); err != nil {
		t.Errorf("GetGate() failed: %v", err)
	}
	if _, err := cfg.GetAllGates(); err != nil {
		t.Errorf("GetAllGates() failed: %v", err)
	}
	if _, err := cfg.GetAllConnections(); err != nil {
		t.Errorf("GetAllConnections() failed: %v", err)
	}
	if _, err := cfg.HasOhmic(ohmic); err != nil {
		t.Errorf("HasOhmic() failed: %v", err)
	}
	if _, err := cfg.HasGate(gate); err != nil {
		t.Errorf("HasGate() failed: %v", err)
	}
	if _, err := cfg.HasBarrierGate(gate); err != nil {
		t.Errorf("HasBarrierGate() failed: %v", err)
	}
	if _, err := cfg.HasPlungerGate(plungerConn); err != nil {
		t.Errorf("HasPlungerGate() failed: %v", err)
	}
	if _, err := cfg.HasReservoirGate(reservoir); err != nil {
		t.Errorf("HasReservoirGate() failed: %v", err)
	}
	if _, err := cfg.HasScreeningGate(screeningConn); err != nil {
		t.Errorf("HasScreeningGate() failed: %v", err)
	}

	// Equality and NotEqual
	cfg2 := makeFixtureConfig(t)
	defer cfg2.Close()
	eq, err := cfg.Equal(cfg2)
	if err != nil || !eq {
		t.Errorf("Equal failed: %v, eq=%v", err, eq)
	}
	neq, err := cfg.NotEqual(cfg2)
	if err != nil || neq {
		t.Errorf("NotEqual failed: %v, neq=%v", err, neq)
	}

	// ToJSON/FromJSON
	js, err := cfg.ToJSON()
	if err != nil || js == "" {
		t.Fatalf("ToJSON failed: %v", err)
	}
	cfg3, err := FromJSON(js)
	if err != nil || cfg3 == nil {
		t.Fatalf("FromJSON failed: %v", err)
	}
	defer cfg3.Close()
	eq, err = cfg.Equal(cfg3)
	if err != nil || !eq {
		t.Errorf("ToJSON/FromJSON roundtrip failed: eq=%v, err=%v", eq, err)
	}
}

func TestConfig_ErrorBranches(t *testing.T) {
	cfg := makeFixtureConfig(t)
	cfg.Close()
	tests := []struct {
		name string
		test func() error
	}{
		{"VoltageConstraints", func() error { _, err := cfg.VoltageConstraints(); return err }},
		{"Groups", func() error { _, err := cfg.Groups(); return err }},
		{"WiringDc", func() error { _, err := cfg.WiringDc(); return err }},
		{"Channels", func() error { _, err := cfg.Channels(); return err }},
		{"ToJSON", func() error { _, err := cfg.ToJSON(); return err }},
		{"Equal", func() error { _, err := cfg.Equal(cfg); return err }},
		{"NotEqual", func() error { _, err := cfg.NotEqual(cfg); return err }},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			if err := tc.test(); err == nil {
				t.Errorf("Expected error from %s() on closed config", tc.name)
			}
		})
	}
}

func TestConfig_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}
