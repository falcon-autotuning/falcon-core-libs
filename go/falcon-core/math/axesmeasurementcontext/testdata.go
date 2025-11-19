package axesmeasurementcontext

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/measurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

func mustMeasurementContext(conn *connection.Handle, instrumentType string) *measurementcontext.Handle {
	h, err := measurementcontext.New(conn, instrumentType)
	if err != nil {
		panic(fmt.Errorf("failed to create a measurement context: %v", err))
	}
	return h
}

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(fmt.Errorf("failed to create BarrierGate: %v", err))
	}
	return h
}

var (
	defaultAxesData = []*measurementcontext.Handle{
		mustMeasurementContext(mustBarrierGate("B1"), instrumenttypes.VoltageSource()),
		mustMeasurementContext(mustBarrierGate("B2"), instrumenttypes.VoltageSource()),
	}
	otherAxesData = []*measurementcontext.Handle{
		mustMeasurementContext(mustBarrierGate("B3"), instrumenttypes.VoltageSource()),
	}
)
