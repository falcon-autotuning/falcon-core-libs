package mapinterpretationcontextquantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapInterpretationContextQuantity_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listinterpretationcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairinterpretationcontextquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairinterpretationcontextquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
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
		C.MapInterpretationContextQuantity_destroy(C.MapInterpretationContextQuantityHandle(ptr))
	}
)

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
			return unsafe.Pointer(C.MapInterpretationContextQuantity_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MapInterpretationContextQuantity_copy(C.MapInterpretationContextQuantityHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairinterpretationcontextquantity.Handle) (*Handle, error) {
	n := len(data)
	if n == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	size := C.size_t(n) * C.size_t(unsafe.Sizeof(C.PairInterpretationContextQuantityHandle(nil)))
	cList := C.malloc(size)
	if cList == nil {
		return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.PairInterpretationContextQuantityHandle)(cList)[:n:n]
	for i, v := range data {
		slice[i] = C.PairInterpretationContextQuantityHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MapInterpretationContextQuantity_create((*C.PairInterpretationContextQuantityHandle)(cList), C.size_t(n)))
			C.free(cList)
			return res, nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) InsertOrAssign(key *interpretationcontext.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapInterpretationContextQuantity_insert_or_assign(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *interpretationcontext.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapInterpretationContextQuantity_insert(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *interpretationcontext.Handle) (*quantity.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*quantity.Handle, error) {

		return quantity.FromCAPI(unsafe.Pointer(C.MapInterpretationContextQuantity_at(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *interpretationcontext.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapInterpretationContextQuantity_erase(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MapInterpretationContextQuantity_size(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapInterpretationContextQuantity_empty(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapInterpretationContextQuantity_clear(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *interpretationcontext.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapInterpretationContextQuantity_contains(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.MapInterpretationContextQuantity_keys(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listquantity.Handle, error) {

		return listquantity.FromCAPI(unsafe.Pointer(C.MapInterpretationContextQuantity_values(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairinterpretationcontextquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairinterpretationcontextquantity.Handle, error) {

		return listpairinterpretationcontextquantity.FromCAPI(unsafe.Pointer(C.MapInterpretationContextQuantity_items(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapInterpretationContextQuantity_equal(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()), C.MapInterpretationContextQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapInterpretationContextQuantity_not_equal(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()), C.MapInterpretationContextQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapInterpretationContextQuantity_to_json_string(C.MapInterpretationContextQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapInterpretationContextQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
