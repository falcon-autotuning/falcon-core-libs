package listimpedance

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/impedance"
)

func mustImpedance(name string, resistance float64, capacitance float64) *impedance.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(fmt.Errorf("failed to create BarrierGate: %v", err))
	}
	i, err := impedance.New(h, resistance, capacitance)
	return i
}

var (
	defaultListData = []*impedance.Handle{
		mustImpedance("P1", 1.0, 2.0),
		mustImpedance("B1", 3.0, 4.0),
	}
	val1          = mustImpedance("B2", 5.0, 3.0)
	otherListData = []*impedance.Handle{
		mustImpedance("P2", 0.0, 4.0),
	}
	defaultElemType = mustImpedance("B1", 0.0, 1.0)
)
