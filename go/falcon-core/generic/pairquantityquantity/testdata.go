package pairquantityquantity

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

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

var (
	defaultQuantity  = mustQuantity(1.0)
	defaultQuantity2 = mustQuantity(2.0)
	otherQuantity    = mustQuantity(3.2)
	otherQuantity2   = mustQuantity(4.2)
)
