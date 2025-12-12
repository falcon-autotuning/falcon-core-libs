package mapintint

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapIntInt_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairintint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairintint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.MapIntInt_destroy(C.MapIntIntHandle(ptr))
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
			return unsafe.Pointer(C.MapIntInt_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MapIntInt_copy(C.MapIntIntHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairintint.Handle) (*Handle, error) {
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
	cData := C.malloc(C.size_t(nData) * C.size_t(unsafe.Sizeof(C.PairIntIntHandle(nil))))
	if cData == nil {
		return nil, errors.New("C.malloc failed")
	}
	slicecData := (*[1 << 30]C.PairIntIntHandle)(cData)[:nData:nData]
	for i, v := range data {
		slicecData[i] = C.PairIntIntHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MapIntInt_create((*C.PairIntIntHandle)(cData), C.size_t(nData)))
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
func (h *Handle) InsertOrAssign(key int32, value int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MapIntInt_insert_or_assign(C.MapIntIntHandle(h.CAPIHandle()), C.int(key), C.int(value))
		return nil
	})
}
func (h *Handle) Insert(key int32, value int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MapIntInt_insert(C.MapIntIntHandle(h.CAPIHandle()), C.int(key), C.int(value))
		return nil
	})
}
func (h *Handle) At(key int32) (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.MapIntInt_at(C.MapIntIntHandle(h.CAPIHandle()), C.int(key))), nil
	})
}
func (h *Handle) Erase(key int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MapIntInt_erase(C.MapIntIntHandle(h.CAPIHandle()), C.int(key))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MapIntInt_size(C.MapIntIntHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapIntInt_empty(C.MapIntIntHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapIntInt_clear(C.MapIntIntHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key int32) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapIntInt_contains(C.MapIntIntHandle(h.CAPIHandle()), C.int(key))), nil
	})
}
func (h *Handle) Keys() (*listint.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listint.Handle, error) {

		return listint.FromCAPI(unsafe.Pointer(C.MapIntInt_keys(C.MapIntIntHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listint.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listint.Handle, error) {

		return listint.FromCAPI(unsafe.Pointer(C.MapIntInt_values(C.MapIntIntHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairintint.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairintint.Handle, error) {

		return listpairintint.FromCAPI(unsafe.Pointer(C.MapIntInt_items(C.MapIntIntHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapIntInt_equal(C.MapIntIntHandle(h.CAPIHandle()), C.MapIntIntHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapIntInt_not_equal(C.MapIntIntHandle(h.CAPIHandle()), C.MapIntIntHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapIntInt_to_json_string(C.MapIntIntHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapIntInt_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
