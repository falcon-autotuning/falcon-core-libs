package listpairconnectionpairquantityquantity

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionpairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustPairConnectionPairQuantityQuantity(conn *connection.Handle, p *pairquantityquantity.Handle) *pairconnectionpairquantityquantity.Handle {
	h, err := pairconnectionpairquantityquantity.New(conn, p)
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

func mustPairQuantityQuantity(q1 *quantity.Handle, q2 *quantity.Handle) *pairquantityquantity.Handle {
	h, err := pairquantityquantity.New(q1, q2)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairconnectionpairquantityquantity.Handle{
		mustPairConnectionPairQuantityQuantity(mustBarrierGate("Chan1"), mustPairQuantityQuantity(mustQuantity(1.1), mustQuantity(1.3))),
		mustPairConnectionPairQuantityQuantity(mustBarrierGate("Chan2"), mustPairQuantityQuantity(mustQuantity(1.9), mustQuantity(1.5))),
	}
	otherListData = []*pairconnectionpairquantityquantity.Handle{
		mustPairConnectionPairQuantityQuantity(mustBarrierGate("Chan3"), mustPairQuantityQuantity(mustQuantity(1.0), mustQuantity(1.5))),
	}
)
