package mapgnamegroup

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapGnameGroup_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/gname"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listgname"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listgroup"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairgnamegroup"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairgnamegroup"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/group"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.MapGnameGroup_destroy(C.MapGnameGroupHandle(ptr))
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
			return unsafe.Pointer(C.MapGnameGroup_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(data []*pairgnamegroup.Handle) (*Handle, error) {
	list := make([]C.PairGnameGroupHandle, len(data))
	for i, v := range data {
		list[i] = C.PairGnameGroupHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.MapGnameGroup_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) InsertOrAssign(key *gname.Handle, value *group.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapGnameGroup_insert_or_assign(C.MapGnameGroupHandle(h.CAPIHandle()), C.GnameHandle(key.CAPIHandle()), C.GroupHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *gname.Handle, value *group.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapGnameGroup_insert(C.MapGnameGroupHandle(h.CAPIHandle()), C.GnameHandle(key.CAPIHandle()), C.GroupHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *gname.Handle) (*group.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*group.Handle, error) {

		return group.FromCAPI(unsafe.Pointer(C.MapGnameGroup_at(C.MapGnameGroupHandle(h.CAPIHandle()), C.GnameHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *gname.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapGnameGroup_erase(C.MapGnameGroupHandle(h.CAPIHandle()), C.GnameHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.MapGnameGroup_size(C.MapGnameGroupHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapGnameGroup_empty(C.MapGnameGroupHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapGnameGroup_clear(C.MapGnameGroupHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *gname.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapGnameGroup_contains(C.MapGnameGroupHandle(h.CAPIHandle()), C.GnameHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listgname.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listgname.Handle, error) {

		return listgname.FromCAPI(unsafe.Pointer(C.MapGnameGroup_keys(C.MapGnameGroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listgroup.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listgroup.Handle, error) {

		return listgroup.FromCAPI(unsafe.Pointer(C.MapGnameGroup_values(C.MapGnameGroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairgnamegroup.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairgnamegroup.Handle, error) {

		return listpairgnamegroup.FromCAPI(unsafe.Pointer(C.MapGnameGroup_items(C.MapGnameGroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapGnameGroup_equal(C.MapGnameGroupHandle(h.CAPIHandle()), C.MapGnameGroupHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapGnameGroup_not_equal(C.MapGnameGroupHandle(h.CAPIHandle()), C.MapGnameGroupHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapGnameGroup_to_json_string(C.MapGnameGroupHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapGnameGroup_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
