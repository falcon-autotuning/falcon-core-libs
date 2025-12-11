package connection

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"

	// no extra imports
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
		C.Connection_destroy(C.ConnectionHandle(ptr))
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
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Connection_copy(C.ConnectionHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Connection_equal(C.ConnectionHandle(h.CAPIHandle()), C.ConnectionHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Connection_not_equal(C.ConnectionHandle(h.CAPIHandle()), C.ConnectionHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Connection_to_json_string(C.ConnectionHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Connection_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewBarrierGate(name string) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.Read(realname, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Connection_create_barrier_gate(C.StringHandle(realname.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewPlungerGate(name string) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.Read(realname, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Connection_create_plunger_gate(C.StringHandle(realname.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewReservoirGate(name string) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.Read(realname, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Connection_create_reservoir_gate(C.StringHandle(realname.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewScreeningGate(name string) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.Read(realname, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Connection_create_screening_gate(C.StringHandle(realname.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewOhmic(name string) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.Read(realname, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Connection_create_ohmic(C.StringHandle(realname.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Name() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Connection_name(C.ConnectionHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Name:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Type() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Connection_type(C.ConnectionHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Type:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) IsDotGate() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connection_is_dot_gate(C.ConnectionHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsBarrierGate() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connection_is_barrier_gate(C.ConnectionHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsPlungerGate() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connection_is_plunger_gate(C.ConnectionHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsReservoirGate() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connection_is_reservoir_gate(C.ConnectionHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsScreeningGate() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connection_is_screening_gate(C.ConnectionHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsOhmic() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connection_is_ohmic(C.ConnectionHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsGate() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connection_is_gate(C.ConnectionHandle(h.CAPIHandle()))), nil
	})
}
