package pairinterpretationcontextstring

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/measurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/interpretations/interpretationcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
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

var (
	defaultInterpretationContext = mustInterpretationContext([]string{"a", "b"}, []string{"c", "d"})
	otherInterpretationContext   = mustInterpretationContext([]string{"d"}, []string{"c", "e"})
)
