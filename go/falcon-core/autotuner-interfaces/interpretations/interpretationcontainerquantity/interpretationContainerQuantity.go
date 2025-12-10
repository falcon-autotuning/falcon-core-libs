package interpretationcontainerquantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/interpretations/InterpretationContainerQuantity_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listinterpretationcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairinterpretationcontextquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinterpretationcontextquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
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
		C.InterpretationContainerQuantity_destroy(C.InterpretationContainerQuantityHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(contextDoubleMap *mapinterpretationcontextquantity.Handle) (*Handle, error) {
	return cmemoryallocation.Read(contextDoubleMap, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InterpretationContainerQuantity_create(C.MapInterpretationContextQuantityHandle(contextDoubleMap.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InterpretationContainerQuantity_copy(C.InterpretationContainerQuantityHandle(handle.CAPIHandle()))), nil
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

		return symbolunit.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_unit(C.InterpretationContainerQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) SelectByConnection(connection *connection.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connection}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_select_by_connection(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.ConnectionHandle(connection.CAPIHandle()))))
	})
}
func (h *Handle) SelectByConnections(connections *connections.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connections}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_select_by_connections(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.ConnectionsHandle(connections.CAPIHandle()))))
	})
}
func (h *Handle) SelectByIndependentConnection(connection *connection.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connection}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_select_by_independent_connection(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.ConnectionHandle(connection.CAPIHandle()))))
	})
}
func (h *Handle) SelectByDependentConnection(connection *connection.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connection}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_select_by_dependent_connection(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.ConnectionHandle(connection.CAPIHandle()))))
	})
}
func (h *Handle) SelectContexts(independent_connections *listconnection.Handle, dependent_connections *listconnection.Handle) (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, independent_connections, dependent_connections}, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_select_contexts(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.ListConnectionHandle(independent_connections.CAPIHandle()), C.ListConnectionHandle(dependent_connections.CAPIHandle()))))
	})
}
func (h *Handle) InsertOrAssign(key *interpretationcontext.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.InterpretationContainerQuantity_insert_or_assign(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *interpretationcontext.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.InterpretationContainerQuantity_insert(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *interpretationcontext.Handle) (*quantity.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*quantity.Handle, error) {

		return quantity.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_at(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *interpretationcontext.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.InterpretationContainerQuantity_erase(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.InterpretationContainerQuantity_size(C.InterpretationContainerQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.InterpretationContainerQuantity_empty(C.InterpretationContainerQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.InterpretationContainerQuantity_clear(C.InterpretationContainerQuantityHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *interpretationcontext.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.InterpretationContainerQuantity_contains(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_keys(C.InterpretationContainerQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listquantity.Handle, error) {

		return listquantity.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_values(C.InterpretationContainerQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairinterpretationcontextquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairinterpretationcontextquantity.Handle, error) {

		return listpairinterpretationcontextquantity.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_items(C.InterpretationContainerQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.InterpretationContainerQuantity_equal(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.InterpretationContainerQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.InterpretationContainerQuantity_not_equal(C.InterpretationContainerQuantityHandle(h.CAPIHandle()), C.InterpretationContainerQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InterpretationContainerQuantity_to_json_string(C.InterpretationContainerQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.InterpretationContainerQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
