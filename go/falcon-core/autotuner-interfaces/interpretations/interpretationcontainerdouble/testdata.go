package interpretationcontainerdouble

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/measurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/interpretations/interpretationcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinterpretationcontextdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairinterpretationcontextdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustMeasurementContext(conn *connection.Handle, instrumentType string) *measurementcontext.Handle {
	h, err := measurementcontext.New(conn, instrumentType)
	if err != nil {
		panic(fmt.Errorf("failed to create a measurement context: %v", err))
	}
	return h
}

func mustInterpretationContext(indepNames []string, depNames []string) *interpretationcontext.Handle {
	indepList := make([]*measurementcontext.Handle, 0, len(indepNames))
	for _, name := range indepNames {
		indepList = append(indepList, mustMeasurementContext(mustBarrierGate(name), instrumenttypes.VoltageSource()))
	}
	depList := make([]*measurementcontext.Handle, 0, len(depNames))
	for _, name := range depNames {
		depList = append(depList, mustMeasurementContext(mustBarrierGate(name), instrumenttypes.VoltageSource()))
	}
	indepAxes, err := axesmeasurementcontext.New(indepList)
	if err != nil {
		panic(fmt.Errorf("failed to create AxesMeasurementContext: %v", err))
	}
	depListCtx, err := listmeasurementcontext.New(depList)
	if err != nil {
		panic(fmt.Errorf("failed to create ListMeasurementContext: %v", err))
	}
	unit, _ := symbolunit.NewVolt()
	h, err := interpretationcontext.New(indepAxes, depListCtx, unit)
	if err != nil {
		panic(fmt.Errorf("failed to create InterpretationContext: %v", err))
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

func mustVolt() *symbolunit.Handle {
	h, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	return h
}

func mustListConnections(ids ...string) *listconnection.Handle {
	handles := make([]*connection.Handle, len(ids))
	for i, id := range ids {
		h, err := connection.NewBarrierGate(id)
		if err != nil {
			panic(err)
		}
		handles[i] = h
	}
	h, err := listconnection.New(handles)
	if err != nil {
		panic(err)
	}
	return h
}

func mustConnections(conns ...*listconnection.Handle) *connections.Handle {
	length := 0
	for _, conn := range conns {
		size, err := conn.Size()
		if err != nil {
			panic(err)
		}
		length += int(size)
	}
	handles := make([]*connection.Handle, 0, length)
	for _, conn := range conns {
		size, err := conn.Size()
		if err != nil {
			panic(err)
		}
		for i := 0; i < int(size); i++ {
			h, err := conn.At(uint64(i))
			if err != nil {
				panic(err)
			}
			handles = append(handles, h)
		}
	}
	h, err := connections.New(handles)
	if err != nil {
		panic(err)
	}
	return h
}

func mustPairInterpretationContextDouble(ctx *interpretationcontext.Handle, val float64) *pairinterpretationcontextdouble.Handle {
	h, err := pairinterpretationcontextdouble.New(ctx, val)
	if err != nil {
		panic(fmt.Errorf("failed to create pairinterpretationcontextdouble: %v", err))
	}
	return h
}

func mustMapInterpretationContextDouble(ctx *interpretationcontext.Handle, val float64) *mapinterpretationcontextdouble.Handle {
	h, err := mapinterpretationcontextdouble.New([]*pairinterpretationcontextdouble.Handle{
		mustPairInterpretationContextDouble(ctx, val),
	})
	if err != nil {
		panic(err)
	}
	if h == nil {
		panic(fmt.Errorf("failed to create mapinterpretationcontextdouble"))
	}
	return h
}

var (
	testValue               = 0.1
	testConnection          = mustBarrierGate("B1")
	testListConnectionIndep = mustListConnections("B1", "B2")
	testListConnectionDep   = mustListConnections("B3", "B4")
	testConnections         = mustConnections(testListConnectionIndep, testListConnectionDep)
	testInterpretationCtx   = mustInterpretationContext([]string{"B1"}, []string{"B3"})
	testMapHandle           = mustMapInterpretationContextDouble(testInterpretationCtx, testValue)
)
