package adjacency

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/core/Adjacency_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farrayint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlistsizet"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairsizetsizet"
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
		C.Adjacency_destroy(C.AdjacencyHandle(ptr))
	}
)

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
				return unsafe.Pointer(C.Adjacency_copy(C.AdjacencyHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Adjacency_equal(C.AdjacencyHandle(h.CAPIHandle()), C.AdjacencyHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Adjacency_not_equal(C.AdjacencyHandle(h.CAPIHandle()), C.AdjacencyHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Adjacency_to_json_string(C.AdjacencyHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Adjacency_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []int32, shape []int, indexes *connections.Handle) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	cdata := make([]C.int, len(data))
	for i, v := range data {
		cdata[i] = C.int(v)
	}
	return cmemoryallocation.Read(indexes, func() (*Handle, error) {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Adjacency_create(&cdata[0], &cshape[0], C.size_t(len(shape)), C.ConnectionsHandle(indexes))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Indexes() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Adjacency_indexes(C.AdjacencyHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetTruePairs() (*listpairsizetsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairsizetsizet.Handle, error) {

		return listpairsizetsizet.FromCAPI(unsafe.Pointer(C.Adjacency_get_true_pairs(C.AdjacencyHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.Adjacency_size(C.AdjacencyHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Dimension() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.Adjacency_dimension(C.AdjacencyHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Shape() ([]uint64, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.Adjacency_size(C.AdjacencyHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Shape: size errored"), err)
	}
	out := make([]C.size_t, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.Adjacency_shape(C.AdjacencyHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]uint64, dim)
	for i := range out {
		realout[i] = uint64(out[i])

	}
	return realout, nil
}
func (h *Handle) Data() ([]int32, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.Adjacency_size(C.AdjacencyHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Data: size errored"), err)
	}
	out := make([]C.int, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.Adjacency_data(C.AdjacencyHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]int32, dim)
	for i := range out {
		realout[i] = int32(out[i])

	}
	return realout, nil
}
func (h *Handle) TimesEqualsFArray(other *farrayint.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.Adjacency_times_equals_farray(C.AdjacencyHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) TimesFArray(other *farrayint.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Adjacency_times_farray(C.AdjacencyHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Sum() (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.Adjacency_sum(C.AdjacencyHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Where(value int32) (*listlistsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlistsizet.Handle, error) {

		return listlistsizet.FromCAPI(unsafe.Pointer(C.Adjacency_where(C.AdjacencyHandle(h.CAPIHandle()), C.int(value))))
	})
}
func (h *Handle) Flip(axis uint64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Adjacency_flip(C.AdjacencyHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
