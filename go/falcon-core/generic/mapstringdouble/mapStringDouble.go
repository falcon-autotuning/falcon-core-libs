package mapstringdouble

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapStringDouble_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairstringdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringdouble"
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
		C.MapStringDouble_destroy(C.MapStringDoubleHandle(ptr))
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
			return unsafe.Pointer(C.MapStringDouble_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MapStringDouble_copy(C.MapStringDoubleHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairstringdouble.Handle) (*Handle, error) {
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
	size := C.size_t(n) * C.size_t(unsafe.Sizeof(C.PairStringDoubleHandle(nil)))
	cList := C.malloc(size)
	if cList == nil {
		return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.PairStringDoubleHandle)(cList)[:n:n]
	for i, v := range data {
		slice[i] = C.PairStringDoubleHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MapStringDouble_create((*C.PairStringDoubleHandle)(cList), C.size_t(n)))
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
func (h *Handle) InsertOrAssign(key string, value float64) error {
	realkey := str.New(key)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey}, func() error {
		C.MapStringDouble_insert_or_assign(C.MapStringDoubleHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) Insert(key string, value float64) error {
	realkey := str.New(key)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey}, func() error {
		C.MapStringDouble_insert(C.MapStringDoubleHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) At(key string) (float64, error) {
	realkey := str.New(key)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realkey}, func() (float64, error) {
		return float64(C.MapStringDouble_at(C.MapStringDoubleHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))), nil
	})
}
func (h *Handle) Erase(key string) error {
	realkey := str.New(key)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey}, func() error {
		C.MapStringDouble_erase(C.MapStringDoubleHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MapStringDouble_size(C.MapStringDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapStringDouble_empty(C.MapStringDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapStringDouble_clear(C.MapStringDoubleHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key string) (bool, error) {
	realkey := str.New(key)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realkey}, func() (bool, error) {
		return bool(C.MapStringDouble_contains(C.MapStringDoubleHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.MapStringDouble_keys(C.MapStringDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listdouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listdouble.Handle, error) {

		return listdouble.FromCAPI(unsafe.Pointer(C.MapStringDouble_values(C.MapStringDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairstringdouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairstringdouble.Handle, error) {

		return listpairstringdouble.FromCAPI(unsafe.Pointer(C.MapStringDouble_items(C.MapStringDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapStringDouble_equal(C.MapStringDoubleHandle(h.CAPIHandle()), C.MapStringDoubleHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapStringDouble_not_equal(C.MapStringDoubleHandle(h.CAPIHandle()), C.MapStringDoubleHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapStringDouble_to_json_string(C.MapStringDoubleHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapStringDouble_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
