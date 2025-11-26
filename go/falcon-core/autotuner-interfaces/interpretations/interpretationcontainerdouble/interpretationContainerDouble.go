package interpretationcontainerdouble

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/interpretations/InterpretationContainerDouble_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/interpretations/interpretationcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listinterpretationcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairinterpretationcontextdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinterpretationcontextdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
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
		C.InterpretationContainerDouble_destroy(C.InterpretationContainerDoubleHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(contextDoubleMap *mapinterpretationcontextdouble.Handle) (*Handle, error) {
	return cmemoryallocation.Read(contextDoubleMap, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InterpretationContainerDouble_create(C.MapInterpretationContextDoubleHandle(contextDoubleMap.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Unit() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_unit(C.InterpretationContainerDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) SelectByConnection(connection *connection.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connection}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_select_by_connection(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.ConnectionHandle(connection.CAPIHandle()))))
	})
}
func (h *Handle) SelectByConnections(connections *connections.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connections}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_select_by_connections(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.ConnectionsHandle(connections.CAPIHandle()))))
	})
}
func (h *Handle) SelectByIndependentConnection(connection *connection.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connection}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_select_by_independent_connection(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.ConnectionHandle(connection.CAPIHandle()))))
	})
}
func (h *Handle) SelectByDependentConnection(connection *connection.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connection}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_select_by_dependent_connection(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.ConnectionHandle(connection.CAPIHandle()))))
	})
}
func (h *Handle) SelectContexts(independent_connections *listconnection.Handle, dependent_connections *listconnection.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, independent_connections, dependent_connections}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_select_contexts(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.ListConnectionHandle(independent_connections.CAPIHandle()), C.ListConnectionHandle(dependent_connections.CAPIHandle()))))
	})
}
func (h *Handle) InsertOrAssign(key *interpretationcontext.Handle, value float64) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.InterpretationContainerDouble_insert_or_assign(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) Insert(key *interpretationcontext.Handle, value float64) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.InterpretationContainerDouble_insert(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) At(key *interpretationcontext.Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (float64, error) {
		return float64(C.InterpretationContainerDouble_at(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Erase(key *interpretationcontext.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.InterpretationContainerDouble_erase(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.InterpretationContainerDouble_size(C.InterpretationContainerDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.InterpretationContainerDouble_empty(C.InterpretationContainerDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.InterpretationContainerDouble_clear(C.InterpretationContainerDoubleHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *interpretationcontext.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.InterpretationContainerDouble_contains(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_keys(C.InterpretationContainerDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listdouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listdouble.Handle, error) {

		return listdouble.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_values(C.InterpretationContainerDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairinterpretationcontextdouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairinterpretationcontextdouble.Handle, error) {

		return listpairinterpretationcontextdouble.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_items(C.InterpretationContainerDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.InterpretationContainerDouble_equal(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.InterpretationContainerDoubleHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.InterpretationContainerDouble_not_equal(C.InterpretationContainerDoubleHandle(h.CAPIHandle()), C.InterpretationContainerDoubleHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InterpretationContainerDouble_to_json_string(C.InterpretationContainerDoubleHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.InterpretationContainerDouble_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
