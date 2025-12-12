package mapstringbool

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapStringBool_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringbool"
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
		C.MapStringBool_destroy(C.MapStringBoolHandle(ptr))
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
			return unsafe.Pointer(C.MapStringBool_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MapStringBool_copy(C.MapStringBoolHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairstringbool.Handle) (*Handle, error) {
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
	cData := C.malloc(C.size_t(nData) * C.size_t(unsafe.Sizeof(C.PairStringBoolHandle(nil))))
	if cData == nil {
		return nil, errors.New("C.malloc failed")
	}
	slicecData := (*[1 << 30]C.PairStringBoolHandle)(cData)[:nData:nData]
	for i, v := range data {
		slicecData[i] = C.PairStringBoolHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MapStringBool_create((*C.PairStringBoolHandle)(cData), C.size_t(nData)))
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
func (h *Handle) InsertOrAssign(key string, value bool) error {
	realkey := str.New(key)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey}, func() error {
		C.MapStringBool_insert_or_assign(C.MapStringBoolHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()), C.bool(value))
		return nil
	})
}
func (h *Handle) Insert(key string, value bool) error {
	realkey := str.New(key)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey}, func() error {
		C.MapStringBool_insert(C.MapStringBoolHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()), C.bool(value))
		return nil
	})
}
func (h *Handle) At(key string) (bool, error) {
	realkey := str.New(key)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realkey}, func() (bool, error) {
		return bool(C.MapStringBool_at(C.MapStringBoolHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))), nil
	})
}
func (h *Handle) Erase(key string) error {
	realkey := str.New(key)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realkey}, func() error {
		C.MapStringBool_erase(C.MapStringBoolHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MapStringBool_size(C.MapStringBoolHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapStringBool_empty(C.MapStringBoolHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapStringBool_clear(C.MapStringBoolHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key string) (bool, error) {
	realkey := str.New(key)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realkey}, func() (bool, error) {
		return bool(C.MapStringBool_contains(C.MapStringBoolHandle(h.CAPIHandle()), C.StringHandle(realkey.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.MapStringBool_keys(C.MapStringBoolHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listbool.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listbool.Handle, error) {

		return listbool.FromCAPI(unsafe.Pointer(C.MapStringBool_values(C.MapStringBoolHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairstringbool.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairstringbool.Handle, error) {

		return listpairstringbool.FromCAPI(unsafe.Pointer(C.MapStringBool_items(C.MapStringBoolHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapStringBool_equal(C.MapStringBoolHandle(h.CAPIHandle()), C.MapStringBoolHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapStringBool_not_equal(C.MapStringBoolHandle(h.CAPIHandle()), C.MapStringBoolHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapStringBool_to_json_string(C.MapStringBoolHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapStringBool_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
