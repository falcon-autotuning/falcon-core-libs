package listdevicevoltagestate

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListDeviceVoltageState_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
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
		C.ListDeviceVoltageState_destroy(C.ListDeviceVoltageStateHandle(ptr))
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
			return unsafe.Pointer(C.ListDeviceVoltageState_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint32, value *devicevoltagestate.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListDeviceVoltageState_fill_value(C.size_t(count), C.DeviceVoltageStateHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*devicevoltagestate.Handle) (*Handle, error) {
	list := make([]C.DeviceVoltageStateHandle, len(data))
	for i, v := range data {
		list[i] = C.DeviceVoltageStateHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListDeviceVoltageState_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *devicevoltagestate.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListDeviceVoltageState_push_back(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.ListDeviceVoltageState_size(C.ListDeviceVoltageStateHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListDeviceVoltageState_empty(C.ListDeviceVoltageStateHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListDeviceVoltageState_erase_at(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListDeviceVoltageState_clear(C.ListDeviceVoltageStateHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*devicevoltagestate.Handle, error) {
	return cmemoryallocation.Read(h, func() (*devicevoltagestate.Handle, error) {

		return devicevoltagestate.FromCAPI(unsafe.Pointer(C.ListDeviceVoltageState_at(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*devicevoltagestate.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListDeviceVoltageState_size(C.ListDeviceVoltageStateHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.DeviceVoltageStateHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListDeviceVoltageState_items(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*devicevoltagestate.Handle, dim)
	for i := range out {
		realout[i], err = devicevoltagestate.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *devicevoltagestate.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListDeviceVoltageState_contains(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *devicevoltagestate.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.ListDeviceVoltageState_index(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListDeviceVoltageState_intersection(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), C.ListDeviceVoltageStateHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListDeviceVoltageState_equal(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), C.ListDeviceVoltageStateHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListDeviceVoltageState_not_equal(C.ListDeviceVoltageStateHandle(h.CAPIHandle()), C.ListDeviceVoltageStateHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListDeviceVoltageState_to_json_string(C.ListDeviceVoltageStateHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListDeviceVoltageState_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
