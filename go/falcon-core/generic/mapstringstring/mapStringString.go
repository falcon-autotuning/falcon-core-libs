package mapstringstring

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapStringString_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairstringstring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringstring"
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
		C.MapStringString_destroy(C.MapStringStringHandle(ptr))
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
			return unsafe.Pointer(C.MapStringString_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MapStringString_copy(C.MapStringStringHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairstringstring.Handle) (*Handle, error) {
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
	size := C.size_t(n) * C.size_t(unsafe.Sizeof(C.PairStringStringHandle(nil)))
	cList := C.malloc(size)
	if cList == nil {
		return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.PairStringStringHandle)(cList)[:n:n]
	for i, v := range data {
		slice[i] = C.PairStringStringHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MapStringString_create((*C.PairStringStringHandle)(cList), C.size_t(n)))
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
func (h *Handle) InsertOrAssign(key string, value string) error {
	realkey := str.New(key)
	realvalue := str.New(value)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey, realvalue}, func() error {
		C.MapStringString_insert_or_assign(C.MapStringStringHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()), C.StringHandle(realvalue.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key string, value string) error {
	realkey := str.New(key)
	realvalue := str.New(value)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey, realvalue}, func() error {
		C.MapStringString_insert(C.MapStringStringHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()), C.StringHandle(realvalue.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key string) (string, error) {
	realkey := str.New(key)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realkey}, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapStringString_at(C.MapStringStringHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))))
		if err != nil {
			return "", errors.New("At:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Erase(key string) error {
	realkey := str.New(key)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey}, func() error {
		C.MapStringString_erase(C.MapStringStringHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MapStringString_size(C.MapStringStringHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapStringString_empty(C.MapStringStringHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapStringString_clear(C.MapStringStringHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key string) (bool, error) {
	realkey := str.New(key)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realkey}, func() (bool, error) {
		return bool(C.MapStringString_contains(C.MapStringStringHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.MapStringString_keys(C.MapStringStringHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.MapStringString_values(C.MapStringStringHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairstringstring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairstringstring.Handle, error) {

		return listpairstringstring.FromCAPI(unsafe.Pointer(C.MapStringString_items(C.MapStringStringHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapStringString_equal(C.MapStringStringHandle(h.CAPIHandle()), C.MapStringStringHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapStringString_not_equal(C.MapStringStringHandle(h.CAPIHandle()), C.MapStringStringHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapStringString_to_json_string(C.MapStringStringHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapStringString_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
