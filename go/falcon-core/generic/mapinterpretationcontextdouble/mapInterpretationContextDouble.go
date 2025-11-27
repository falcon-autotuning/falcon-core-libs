package mapinterpretationcontextdouble

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapInterpretationContextDouble_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listinterpretationcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairinterpretationcontextdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairinterpretationcontextdouble"
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
		C.MapInterpretationContextDouble_destroy(C.MapInterpretationContextDoubleHandle(ptr))
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
			return unsafe.Pointer(C.MapInterpretationContextDouble_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(data []*pairinterpretationcontextdouble.Handle) (*Handle, error) {
	list := make([]C.PairInterpretationContextDoubleHandle, len(data))
	for i, v := range data {
		list[i] = C.PairInterpretationContextDoubleHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.MapInterpretationContextDouble_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) InsertOrAssign(key *interpretationcontext.Handle, value float64) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapInterpretationContextDouble_insert_or_assign(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) Insert(key *interpretationcontext.Handle, value float64) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapInterpretationContextDouble_insert(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) At(key *interpretationcontext.Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (float64, error) {
		return float64(C.MapInterpretationContextDouble_at(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Erase(key *interpretationcontext.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapInterpretationContextDouble_erase(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.MapInterpretationContextDouble_size(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapInterpretationContextDouble_empty(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapInterpretationContextDouble_clear(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *interpretationcontext.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapInterpretationContextDouble_contains(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()), C.InterpretationContextHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listinterpretationcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listinterpretationcontext.Handle, error) {

		return listinterpretationcontext.FromCAPI(unsafe.Pointer(C.MapInterpretationContextDouble_keys(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listdouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listdouble.Handle, error) {

		return listdouble.FromCAPI(unsafe.Pointer(C.MapInterpretationContextDouble_values(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairinterpretationcontextdouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairinterpretationcontextdouble.Handle, error) {

		return listpairinterpretationcontextdouble.FromCAPI(unsafe.Pointer(C.MapInterpretationContextDouble_items(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapInterpretationContextDouble_equal(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()), C.MapInterpretationContextDoubleHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapInterpretationContextDouble_not_equal(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()), C.MapInterpretationContextDoubleHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapInterpretationContextDouble_to_json_string(C.MapInterpretationContextDoubleHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapInterpretationContextDouble_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
