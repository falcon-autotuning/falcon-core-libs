package mapchannelconnections

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapChannelConnections_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listchannel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairchannelconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairchannelconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.MapChannelConnections_destroy(C.MapChannelConnectionsHandle(ptr))
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
			return unsafe.Pointer(C.MapChannelConnections_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MapChannelConnections_copy(C.MapChannelConnectionsHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairchannelconnections.Handle) (*Handle, error) {
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
	cData := C.malloc(C.size_t(nData) * C.size_t(unsafe.Sizeof(C.PairChannelConnectionsHandle(nil))))
	if cData == nil {
		return nil, errors.New("C.malloc failed")
	}
	slicecData := (*[1 << 30]C.PairChannelConnectionsHandle)(cData)[:nData:nData]
	for i, v := range data {
		slicecData[i] = C.PairChannelConnectionsHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MapChannelConnections_create((*C.PairChannelConnectionsHandle)(cData), C.size_t(nData)))
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
func (h *Handle) InsertOrAssign(key *channel.Handle, value *connections.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapChannelConnections_insert_or_assign(C.MapChannelConnectionsHandle(h.CAPIHandle()), C.ChannelHandle(key.CAPIHandle()), C.ConnectionsHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *channel.Handle, value *connections.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapChannelConnections_insert(C.MapChannelConnectionsHandle(h.CAPIHandle()), C.ChannelHandle(key.CAPIHandle()), C.ConnectionsHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.MapChannelConnections_at(C.MapChannelConnectionsHandle(h.CAPIHandle()), C.ChannelHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *channel.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapChannelConnections_erase(C.MapChannelConnectionsHandle(h.CAPIHandle()), C.ChannelHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MapChannelConnections_size(C.MapChannelConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapChannelConnections_empty(C.MapChannelConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapChannelConnections_clear(C.MapChannelConnectionsHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *channel.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapChannelConnections_contains(C.MapChannelConnectionsHandle(h.CAPIHandle()), C.ChannelHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listchannel.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listchannel.Handle, error) {

		return listchannel.FromCAPI(unsafe.Pointer(C.MapChannelConnections_keys(C.MapChannelConnectionsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnections.Handle, error) {

		return listconnections.FromCAPI(unsafe.Pointer(C.MapChannelConnections_values(C.MapChannelConnectionsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairchannelconnections.Handle, error) {

		return listpairchannelconnections.FromCAPI(unsafe.Pointer(C.MapChannelConnections_items(C.MapChannelConnectionsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapChannelConnections_equal(C.MapChannelConnectionsHandle(h.CAPIHandle()), C.MapChannelConnectionsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapChannelConnections_not_equal(C.MapChannelConnectionsHandle(h.CAPIHandle()), C.MapChannelConnectionsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapChannelConnections_to_json_string(C.MapChannelConnectionsHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapChannelConnections_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
