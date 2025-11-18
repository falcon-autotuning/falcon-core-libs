package listquantity

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

// ... more helpers as needed

var (
	defaultListData = []*quantity.Handle{
		mustQuantity(1.1),
		mustQuantity(1.9),
	}
	otherListData = []*quantity.Handle{
		mustQuantity(1.0),
	}
)
