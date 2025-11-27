package mapinstrumentportporttransform

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapInstrumentPortPortTransform_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listinstrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairinstrumentportporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairinstrumentportporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.MapInstrumentPortPortTransform_destroy(C.MapInstrumentPortPortTransformHandle(ptr))
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
			return unsafe.Pointer(C.MapInstrumentPortPortTransform_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(data []*pairinstrumentportporttransform.Handle) (*Handle, error) {
	list := make([]C.PairInstrumentPortPortTransformHandle, len(data))
	for i, v := range data {
		list[i] = C.PairInstrumentPortPortTransformHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.MapInstrumentPortPortTransform_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) InsertOrAssign(key *instrumentport.Handle, value *porttransform.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapInstrumentPortPortTransform_insert_or_assign(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()), C.PortTransformHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *instrumentport.Handle, value *porttransform.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapInstrumentPortPortTransform_insert(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()), C.PortTransformHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *instrumentport.Handle) (*porttransform.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*porttransform.Handle, error) {

		return porttransform.FromCAPI(unsafe.Pointer(C.MapInstrumentPortPortTransform_at(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *instrumentport.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapInstrumentPortPortTransform_erase(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.MapInstrumentPortPortTransform_size(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapInstrumentPortPortTransform_empty(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapInstrumentPortPortTransform_clear(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *instrumentport.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapInstrumentPortPortTransform_contains(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()), C.InstrumentPortHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listinstrumentport.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listinstrumentport.Handle, error) {

		return listinstrumentport.FromCAPI(unsafe.Pointer(C.MapInstrumentPortPortTransform_keys(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listporttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listporttransform.Handle, error) {

		return listporttransform.FromCAPI(unsafe.Pointer(C.MapInstrumentPortPortTransform_values(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairinstrumentportporttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairinstrumentportporttransform.Handle, error) {

		return listpairinstrumentportporttransform.FromCAPI(unsafe.Pointer(C.MapInstrumentPortPortTransform_items(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapInstrumentPortPortTransform_equal(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()), C.MapInstrumentPortPortTransformHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapInstrumentPortPortTransform_not_equal(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()), C.MapInstrumentPortPortTransformHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapInstrumentPortPortTransform_to_json_string(C.MapInstrumentPortPortTransformHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapInstrumentPortPortTransform_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
