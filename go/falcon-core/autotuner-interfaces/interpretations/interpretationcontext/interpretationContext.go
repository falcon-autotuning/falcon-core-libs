package interpretationcontext

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/interpretations/InterpretationContext_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/measurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.InterpretationContext_destroy(C.InterpretationContextHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(independant_variables *axesmeasurementcontext.Handle, dependant_variables *listmeasurementcontext.Handle, unit *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{independant_variables, dependant_variables, unit}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InterpretationContext_create(C.AxesMeasurementContextHandle(independant_variables.CAPIHandle()), C.ListMeasurementContextHandle(dependant_variables.CAPIHandle()), C.SymbolUnitHandle(unit.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) IndependentVariables() (*axesmeasurementcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*axesmeasurementcontext.Handle, error) {

		return axesmeasurementcontext.FromCAPI(unsafe.Pointer(C.InterpretationContext_independent_variables(C.InterpretationContextHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) DependentVariables() (*listmeasurementcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listmeasurementcontext.Handle, error) {

		return listmeasurementcontext.FromCAPI(unsafe.Pointer(C.InterpretationContext_dependent_variables(C.InterpretationContextHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Unit() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.InterpretationContext_unit(C.InterpretationContextHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Dimension() (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.InterpretationContext_dimension(C.InterpretationContextHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) AddDependentVariable(variable *measurementcontext.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{variable}, func() error {
		C.InterpretationContext_add_dependent_variable(C.InterpretationContextHandle(h.CAPIHandle()), C.MeasurementContextHandle(variable.CAPIHandle()))
		return nil
	})
}
func (h *Handle) ReplaceDependentVariable(index int32, variable *measurementcontext.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{index, variable}, func() error {
		C.InterpretationContext_replace_dependent_variable(C.InterpretationContextHandle(h.CAPIHandle()), C.int(index), C.MeasurementContextHandle(variable.CAPIHandle()))
		return nil
	})
}
func (h *Handle) GetIndependentVariables(index int32) (*measurementcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*measurementcontext.Handle, error) {

		return measurementcontext.FromCAPI(unsafe.Pointer(C.InterpretationContext_get_independent_variables(C.InterpretationContextHandle(h.CAPIHandle()), C.int(index))))
	})
}
func (h *Handle) WithUnit(unit *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, unit}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.InterpretationContext_with_unit(C.InterpretationContextHandle(h.CAPIHandle()), C.SymbolUnitHandle(unit.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.InterpretationContext_equal(C.InterpretationContextHandle(h.CAPIHandle()), C.InterpretationContextHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.InterpretationContext_not_equal(C.InterpretationContextHandle(h.CAPIHandle()), C.InterpretationContextHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InterpretationContext_to_json_string(C.InterpretationContextHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("ToJSON:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func FromJSON(json string) (*Handle, error) {
	realjson := str.New(json)
	return cmemoryallocation.Read(realjson, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InterpretationContext_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
