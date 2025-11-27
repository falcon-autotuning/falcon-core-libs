package listpairconnectionquantity

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustPairConnectionQuantity(conn *connection.Handle, q *quantity.Handle) *pairconnectionquantity.Handle {
	h, err := pairconnectionquantity.New(conn, q)
	if err != nil {
		panic(err)
	}
	return h
}

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(err)
	}
	return h
}

func mustVolt() *symbolunit.Handle {
	h, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	return h
}

func mustQuantity(val float64) *quantity.Handle {
	h, err := quantity.New(val, mustVolt())
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairconnectionquantity.Handle{
		mustPairConnectionQuantity(mustBarrierGate("Chan1"), mustQuantity(1.1)),
		mustPairConnectionQuantity(mustBarrierGate("Chan2"), mustQuantity(1.9)),
	}
	otherListData = []*pairconnectionquantity.Handle{
		mustPairConnectionQuantity(mustBarrierGate("Chan3"), mustQuantity(1.0)),
	}
)
