package vector

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/Vector_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectionpairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/point"
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
		C.Vector_destroy(C.VectorHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(start *point.Handle, end *point.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{start, end}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Vector_create(C.PointHandle(start.CAPIHandle()), C.PointHandle(end.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromEnd(end *point.Handle) (*Handle, error) {
	return cmemoryallocation.Read(end, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Vector_create_from_end(C.PointHandle(end.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromQuantities(start *mapconnectionquantity.Handle, end *mapconnectionquantity.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{start, end}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Vector_create_from_quantities(C.MapConnectionQuantityHandle(start.CAPIHandle()), C.MapConnectionQuantityHandle(end.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromEndQuantities(end *mapconnectionquantity.Handle) (*Handle, error) {
	return cmemoryallocation.Read(end, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Vector_create_from_end_quantities(C.MapConnectionQuantityHandle(end.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromDoubles(start *mapconnectiondouble.Handle, end *mapconnectiondouble.Handle, unit *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{start, end, unit}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Vector_create_from_doubles(C.MapConnectionDoubleHandle(start.CAPIHandle()), C.MapConnectionDoubleHandle(end.CAPIHandle()), C.SymbolUnitHandle(unit.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromEndDoubles(end *mapconnectiondouble.Handle, unit *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{end, unit}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Vector_create_from_end_doubles(C.MapConnectionDoubleHandle(end.CAPIHandle()), C.SymbolUnitHandle(unit.CAPIHandle()))), nil
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
				return unsafe.Pointer(C.Vector_create_from_parent(C.MapConnectionQuantityHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) EndPoint() (*point.Handle, error) {
	return cmemoryallocation.Read(h, func() (*point.Handle, error) {

		return point.FromCAPI(unsafe.Pointer(C.Vector_end_point(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) StartPoint() (*point.Handle, error) {
	return cmemoryallocation.Read(h, func() (*point.Handle, error) {

		return point.FromCAPI(unsafe.Pointer(C.Vector_start_point(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) EndQuantities() (*mapconnectionquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapconnectionquantity.Handle, error) {

		return mapconnectionquantity.FromCAPI(unsafe.Pointer(C.Vector_end_quantities(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) StartQuantities() (*mapconnectionquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapconnectionquantity.Handle, error) {

		return mapconnectionquantity.FromCAPI(unsafe.Pointer(C.Vector_start_quantities(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) EndMap() (*mapconnectiondouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapconnectiondouble.Handle, error) {

		return mapconnectiondouble.FromCAPI(unsafe.Pointer(C.Vector_end_map(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) StartMap() (*mapconnectiondouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapconnectiondouble.Handle, error) {

		return mapconnectiondouble.FromCAPI(unsafe.Pointer(C.Vector_start_map(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Connections() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.Vector_connections(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Unit() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.Vector_unit(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) PrincipleConnection() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Vector_principle_connection(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Magnitude() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Vector_magnitude(C.VectorHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) InsertOrAssign(key *connection.Handle, value *pairquantityquantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.Vector_insert_or_assign(C.VectorHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.PairQuantityQuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *connection.Handle, value *pairquantityquantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.Vector_insert(C.VectorHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.PairQuantityQuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *connection.Handle) (*pairquantityquantity.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*pairquantityquantity.Handle, error) {

		return pairquantityquantity.FromCAPI(unsafe.Pointer(C.Vector_at(C.VectorHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *connection.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.Vector_erase(C.VectorHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.Vector_size(C.VectorHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Vector_empty(C.VectorHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.Vector_clear(C.VectorHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.Vector_contains(C.VectorHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.Vector_keys(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listpairquantityquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairquantityquantity.Handle, error) {

		return listpairquantityquantity.FromCAPI(unsafe.Pointer(C.Vector_values(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairconnectionpairquantityquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairconnectionpairquantityquantity.Handle, error) {

		return listpairconnectionpairquantityquantity.FromCAPI(unsafe.Pointer(C.Vector_items(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Addition(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_addition(C.VectorHandle(h.CAPIHandle()), C.VectorHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Subtraction(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_subtraction(C.VectorHandle(h.CAPIHandle()), C.VectorHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DoubleMultiplication(scalar float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_double_multiplication(C.VectorHandle(h.CAPIHandle()), C.double(scalar))))
	})
}
func (h *Handle) IntMultiplication(scalar int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_int_multiplication(C.VectorHandle(h.CAPIHandle()), C.int(scalar))))
	})
}
func (h *Handle) DoubleDivision(scalar float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_double_division(C.VectorHandle(h.CAPIHandle()), C.double(scalar))))
	})
}
func (h *Handle) IntDivision(scalar int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_int_division(C.VectorHandle(h.CAPIHandle()), C.int(scalar))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_negation(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) UpdateStartFromStates(state *devicevoltagestates.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, state}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_update_start_from_states(C.VectorHandle(h.CAPIHandle()), C.DeviceVoltageStatesHandle(state.CAPIHandle()))))
	})
}
func (h *Handle) TranslateDoubles(point *mapconnectiondouble.Handle, unit *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, point, unit}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_translate_doubles(C.VectorHandle(h.CAPIHandle()), C.MapConnectionDoubleHandle(point.CAPIHandle()), C.SymbolUnitHandle(unit.CAPIHandle()))))
	})
}
func (h *Handle) TranslateQuantities(point *mapconnectionquantity.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, point}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_translate_quantities(C.VectorHandle(h.CAPIHandle()), C.MapConnectionQuantityHandle(point.CAPIHandle()))))
	})
}
func (h *Handle) Translate(point *point.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, point}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_translate(C.VectorHandle(h.CAPIHandle()), C.PointHandle(point.CAPIHandle()))))
	})
}
func (h *Handle) TranslateToOrigin() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_translate_to_origin(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) DoubleExtend(extension float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_double_extend(C.VectorHandle(h.CAPIHandle()), C.double(extension))))
	})
}
func (h *Handle) IntExtend(extension int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_int_extend(C.VectorHandle(h.CAPIHandle()), C.int(extension))))
	})
}
func (h *Handle) DoubleShrink(extension float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_double_shrink(C.VectorHandle(h.CAPIHandle()), C.double(extension))))
	})
}
func (h *Handle) IntShrink(extension int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_int_shrink(C.VectorHandle(h.CAPIHandle()), C.int(extension))))
	})
}
func (h *Handle) UnitVector() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_unit_vector(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Normalize() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_normalize(C.VectorHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Project(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Vector_project(C.VectorHandle(h.CAPIHandle()), C.VectorHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) UpdateUnit(unit *symbolunit.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{unit}, func() error {
		C.Vector_update_unit(C.VectorHandle(h.CAPIHandle()), C.SymbolUnitHandle(unit.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.Vector_equal(C.VectorHandle(h.CAPIHandle()), C.VectorHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.Vector_not_equal(C.VectorHandle(h.CAPIHandle()), C.VectorHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Vector_to_json_string(C.VectorHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Vector_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
