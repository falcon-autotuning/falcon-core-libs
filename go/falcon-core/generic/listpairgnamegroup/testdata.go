package listpairgnamegroup

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/gname"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairgnamegroup"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/group"
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
	group     *group.Handle
}

func setupGroup(name string) *testGroupConfig {
	ch, err := channel.New(name)
	if err != nil {
		panic(fmt.Errorf("channel.New error: %v", err))
	}
	numDots := int32(2)
	s1, err := connection.NewScreeningGate("s1")
	if err != nil {
		panic(fmt.Errorf("NewScreeningGate(s1): %v", err))
	}
	s2, err := connection.NewScreeningGate("s2")
	if err != nil {
		panic(fmt.Errorf("NewScreeningGate(s2): %v", err))
	}
	screening, err := connections.New([]*connection.Handle{s1, s2})
	if err != nil {
		panic(fmt.Errorf("connections.New(screening): %v", err))
	}
	r1, err := connection.NewReservoirGate("R1")
	if err != nil {
		panic(fmt.Errorf("NewReservoirGate(R1): %v", err))
	}
	r2, err := connection.NewReservoirGate("R2")
	if err != nil {
		panic(fmt.Errorf("NewReservoirGate(R2): %v", err))
	}
	reservoir, err := connections.New([]*connection.Handle{r1, r2})
	if err != nil {
		panic(fmt.Errorf("connections.New(reservoir): %v", err))
	}
	p1, err := connection.NewPlungerGate("P1")
	if err != nil {
		panic(fmt.Errorf("NewPlungerGate(P1): %v", err))
	}
	plunger, err := connections.New([]*connection.Handle{p1})
	if err != nil {
		panic(fmt.Errorf("connections.New(plunger): %v", err))
	}
	b1, err := connection.NewBarrierGate("B1")
	if err != nil {
		panic(fmt.Errorf("NewBarrierGate(B1): %v", err))
	}
	b2, err := connection.NewBarrierGate("B2")
	if err != nil {
		panic(fmt.Errorf("NewBarrierGate(B2): %v", err))
	}
	barrier, err := connections.New([]*connection.Handle{b1, b2})
	if err != nil {
		panic(fmt.Errorf("connections.New(barrier): %v", err))
	}
	o1, err := connection.NewOhmic("O1")
	if err != nil {
		panic(fmt.Errorf("NewOhmic(O1): %v", err))
	}
	o2, err := connection.NewOhmic("O2")
	if err != nil {
		panic(fmt.Errorf("NewOhmic(O2): %v", err))
	}
	orderList := []*connection.Handle{o1, r1, b1, p1, b2, r2, o2}
	order, err := connections.New(orderList)
	if err != nil {
		panic(fmt.Errorf("connections.New(order): %v", err))
	}
	groupHandle, err := group.New(ch, numDots, screening, reservoir, plunger, barrier, order)
	if err != nil {
		panic(fmt.Errorf("group.New error: %v", err))
	}
	return &testGroupConfig{
		channel:   ch,
		numDots:   numDots,
		screening: screening,
		reservoir: reservoir,
		plunger:   plunger,
		barrier:   barrier,
		order:     order,
		group:     groupHandle,
	}
}

func mustPairGnameGroup(name *gname.Handle, g *group.Handle) *pairgnamegroup.Handle {
	h, err := pairgnamegroup.New(name, g)
	if err != nil {
		panic(fmt.Errorf("pairgnamegroup.New error: %v", err))
	}
	return h
}

func mustGname(name string) *gname.Handle {
	h, err := gname.New(name)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultListData = []*pairgnamegroup.Handle{
		mustPairGnameGroup(mustGname("hello"), setupGroup("C1").group),
		mustPairGnameGroup(mustGname("world"), setupGroup("C3").group),
	}
	otherListData = []*pairgnamegroup.Handle{
		mustPairGnameGroup(mustGname("gak"), setupGroup("C2").group),
	}
)
