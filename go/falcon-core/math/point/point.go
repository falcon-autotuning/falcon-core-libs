package point

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/Point_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
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
		C.Point_destroy(C.PointHandle(ptr))
	}
)

func (h *Handle) IsNil() bool { return h == nil }
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Point_copy(C.PointHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Point_equal(C.PointHandle(h.CAPIHandle()), C.PointHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Point_not_equal(C.PointHandle(h.CAPIHandle()), C.PointHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Point_to_json_string(C.PointHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Point_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.Point_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items *mapconnectiondouble.Handle, unit *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{items, unit}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Point_create(C.MapConnectionDoubleHandle(items.CAPIHandle()), C.SymbolUnitHandle(unit.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromParent(items *mapconnectionquantity.Handle) (*Handle, error) {
	return cmemoryallocation.Read(items, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Point_create_from_parent(C.MapConnectionQuantityHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Unit() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.Point_unit(C.PointHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InsertOrAssign(key *connection.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.Point_insert_or_assign(C.PointHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *connection.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.Point_insert(C.PointHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *connection.Handle) (*quantity.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*quantity.Handle, error) {

		return quantity.FromCAPI(unsafe.Pointer(C.Point_at(C.PointHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *connection.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.Point_erase(C.PointHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.Point_size(C.PointHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Point_empty(C.PointHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.Point_clear(C.PointHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.Point_contains(C.PointHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.Point_keys(C.PointHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listquantity.Handle, error) {

		return listquantity.FromCAPI(unsafe.Pointer(C.Point_values(C.PointHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairconnectionquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairconnectionquantity.Handle, error) {

		return listpairconnectionquantity.FromCAPI(unsafe.Pointer(C.Point_items(C.PointHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Coordinates() (*mapconnectionquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapconnectionquantity.Handle, error) {

		return mapconnectionquantity.FromCAPI(unsafe.Pointer(C.Point_coordinates(C.PointHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Connections() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.Point_connections(C.PointHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Addition(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Point_addition(C.PointHandle(h.CAPIHandle()), C.PointHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Subtraction(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Point_subtraction(C.PointHandle(h.CAPIHandle()), C.PointHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Multiplication(scalar float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Point_multiplication(C.PointHandle(h.CAPIHandle()), C.double(scalar))))
	})
}
func (h *Handle) Division(scalar float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Point_division(C.PointHandle(h.CAPIHandle()), C.double(scalar))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Point_negation(C.PointHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) SetUnit(unit *symbolunit.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{unit}, func() error {
		C.Point_set_unit(C.PointHandle(h.CAPIHandle()), C.SymbolUnitHandle(unit.CAPIHandle()))
		return nil
	})
}
