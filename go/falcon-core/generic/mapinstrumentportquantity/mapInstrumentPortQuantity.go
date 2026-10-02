package mapinstrumentportquantity

/*
#cgo pkg-config: falcon-core-c-api
#include <falcon-core/generic/MapInstrumentPortQuantity_c_api.h>
#include <falcon-core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listinstrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairinstrumentportquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairinstrumentportquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.MapInstrumentPortQuantity_destroy(C.MapInstrumentPortQuantityHandle(ptr))
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
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.MapInstrumentPortQuantity_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MapInstrumentPortQuantity_copy(C.MapInstrumentPortQuantityHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairinstrumentportquantity.Handle) (*Handle, error) {
	nData := len(data)
	if nData == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	cData := C.malloc(C.size_t(nData) * C.size_t(unsafe.Sizeof(C.PairInstrumentPortQuantityHandle(nil))))
	if cData == nil {
		return nil, errors.New("C.malloc failed")
	}
	slicecData := (*[1 << 30]C.PairInstrumentPortQuantityHandle)(cData)[:nData:nData]
	for i, v := range data {
		slicecData[i] = C.PairInstrumentPortQuantityHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MapInstrumentPortQuantity_create((*C.PairInstrumentPortQuantityHandle)(cData), C.size_t(nData)))
			C.free(cData)
			return res, nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) InsertOrAssign(key *instrumentport.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapInstrumentPortQuantity_insert_or_assign(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *instrumentport.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapInstrumentPortQuantity_insert(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *instrumentport.Handle) (*quantity.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*quantity.Handle, error) {

		return quantity.FromCAPI(unsafe.Pointer(C.MapInstrumentPortQuantity_at(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *instrumentport.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapInstrumentPortQuantity_erase(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MapInstrumentPortQuantity_size(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapInstrumentPortQuantity_empty(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapInstrumentPortQuantity_clear(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *instrumentport.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapInstrumentPortQuantity_contains(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listinstrumentport.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listinstrumentport.Handle, error) {

		return listinstrumentport.FromCAPI(unsafe.Pointer(C.MapInstrumentPortQuantity_keys(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listquantity.Handle, error) {

		return listquantity.FromCAPI(unsafe.Pointer(C.MapInstrumentPortQuantity_values(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairinstrumentportquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairinstrumentportquantity.Handle, error) {

		return listpairinstrumentportquantity.FromCAPI(unsafe.Pointer(C.MapInstrumentPortQuantity_items(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapInstrumentPortQuantity_equal(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()), C.MapInstrumentPortQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapInstrumentPortQuantity_not_equal(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()), C.MapInstrumentPortQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapInstrumentPortQuantity_to_json_string(C.MapInstrumentPortQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapInstrumentPortQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
