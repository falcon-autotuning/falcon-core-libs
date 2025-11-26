package ports

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/instrument_interfaces/names/Ports_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listinstrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.Ports_destroy(C.PortsHandle(ptr))
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
			return unsafe.Pointer(C.Ports_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*instrumentport.Handle) (*Handle, error) {
	list, err := listinstrumentport.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of instrumentport failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(items *listinstrumentport.Handle) (*Handle, error) {
	return cmemoryallocation.Read(items, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Ports_create(C.ListInstrumentPortHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Ports() (*listinstrumentport.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listinstrumentport.Handle, error) {

		return listinstrumentport.FromCAPI(unsafe.Pointer(C.Ports_ports(C.PortsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) DefaultNames() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.Ports_default_names(C.PortsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetPsuedoNames() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.Ports_get_psuedo_names(C.PortsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetRawNames() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.Ports__get_raw_names(C.PortsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetInstrumentFacingNames() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.Ports__get_instrument_facing_names(C.PortsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetPsuedonameMatchingPort(name *connection.Handle) (*instrumentport.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, name}, func() (*instrumentport.Handle, error) {

		return instrumentport.FromCAPI(unsafe.Pointer(C.Ports__get_psuedoname_matching_port(C.PortsHandle(h.CAPIHandle()), C.ConnectionHandle(name.CAPIHandle()))))
	})
}
func (h *Handle) GetInstrumentTypeMatchingPort(insttype string) (*instrumentport.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, insttype}, func() (*instrumentport.Handle, error) {

		return instrumentport.FromCAPI(unsafe.Pointer(C.Ports__get_instrument_type_matching_port(C.PortsHandle(h.CAPIHandle()), C.StringHandle(insttype.CAPIHandle()))))
	})
}
func (h *Handle) IsKnobs() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Ports_is_knobs(C.PortsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsMeters() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Ports_is_meters(C.PortsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.Ports_intersection(C.PortsHandle(h.CAPIHandle()), C.PortsHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PushBack(value *instrumentport.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.Ports_push_back(C.PortsHandle(h.CAPIHandle()), C.InstrumentPortHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.Ports_size(C.PortsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Ports_empty(C.PortsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.Ports_erase_at(C.PortsHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.Ports_clear(C.PortsHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*instrumentport.Handle, error) {
	return cmemoryallocation.Read(h, func() (*instrumentport.Handle, error) {

		return instrumentport.FromCAPI(unsafe.Pointer(C.Ports_at(C.PortsHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.Ports_items(C.PortsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Contains(value *instrumentport.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.Ports_contains(C.PortsHandle(h.CAPIHandle()), C.InstrumentPortHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *instrumentport.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.Ports_index(C.PortsHandle(h.CAPIHandle()), C.InstrumentPortHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.Ports_equal(C.PortsHandle(h.CAPIHandle()), C.PortsHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.Ports_not_equal(C.PortsHandle(h.CAPIHandle()), C.PortsHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Ports_to_json_string(C.PortsHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Ports_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
