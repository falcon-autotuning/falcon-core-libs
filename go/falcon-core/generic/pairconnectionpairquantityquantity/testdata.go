package pairconnectionpairquantityquantity

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

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

func mustPairQuantityQuantity(vals ...float64) *pairquantityquantity.Handle {
	if len(vals) != 2 {
		panic("mustPairQuantityQuantity requires exactly 2 values")
	}
	q1 := mustQuantity(vals[0])
	q2 := mustQuantity(vals[1])
	h, err := pairquantityquantity.New(q1, q2)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultConnection           = mustBarrierGate("B1")
	defaultPairQuantityQuantity = mustPairQuantityQuantity(1.0, 2.2)
	otherConnection             = mustBarrierGate("B2")
	otherPairQuantityQuantity   = mustPairQuantityQuantity(5.4, 4.3)
)
