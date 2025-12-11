package listwaveform

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListWaveform_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/waveform"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.ListWaveform_destroy(C.ListWaveformHandle(ptr))
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
			return unsafe.Pointer(C.ListWaveform_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListWaveform_copy(C.ListWaveformHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func FillValue(count uint64, value *waveform.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListWaveform_fill_value(C.size_t(count), C.WaveformHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*waveform.Handle) (*Handle, error) {
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
	size := C.size_t(n) * C.size_t(unsafe.Sizeof(C.WaveformHandle(nil)))
	cList := C.malloc(size)
	if cList == nil {
		return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.WaveformHandle)(cList)[:n:n]
	for i, v := range data {
		slice[i] = C.WaveformHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.ListWaveform_create((*C.WaveformHandle)(cList), C.size_t(n)))
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
func (h *Handle) PushBack(value *waveform.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListWaveform_push_back(C.ListWaveformHandle(h.CAPIHandle()), C.WaveformHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ListWaveform_size(C.ListWaveformHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListWaveform_empty(C.ListWaveformHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListWaveform_erase_at(C.ListWaveformHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListWaveform_clear(C.ListWaveformHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*waveform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*waveform.Handle, error) {

		return waveform.FromCAPI(unsafe.Pointer(C.ListWaveform_at(C.ListWaveformHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*waveform.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListWaveform_size(C.ListWaveformHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.WaveformHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListWaveform_items(C.ListWaveformHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*waveform.Handle, dim)
	for i := range out {
		realout[i], err = waveform.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *waveform.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListWaveform_contains(C.ListWaveformHandle(h.CAPIHandle()), C.WaveformHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *waveform.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.ListWaveform_index(C.ListWaveformHandle(h.CAPIHandle()), C.WaveformHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListWaveform_intersection(C.ListWaveformHandle(h.CAPIHandle()), C.ListWaveformHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListWaveform_equal(C.ListWaveformHandle(h.CAPIHandle()), C.ListWaveformHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListWaveform_not_equal(C.ListWaveformHandle(h.CAPIHandle()), C.ListWaveformHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListWaveform_to_json_string(C.ListWaveformHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListWaveform_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
