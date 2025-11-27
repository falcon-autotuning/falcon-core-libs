package listdevicevoltagestate

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustDeviceVoltageState(conn *connection.Handle, val float64) *devicevoltagestate.Handle {
	h, err := devicevoltagestate.New(conn, val, mustVolt())
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

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(fmt.Errorf("failed to create BarrierGate: %v", err))
	}
	return h
}

var (
	defaultListData = []*devicevoltagestate.Handle{
		mustDeviceVoltageState(mustBarrierGate("B1"), 1.0),
		mustDeviceVoltageState(mustBarrierGate("B2"), 1.4),
	}
	otherListData = []*devicevoltagestate.Handle{
		mustDeviceVoltageState(mustBarrierGate("B3"), 1.1),
	}
)
