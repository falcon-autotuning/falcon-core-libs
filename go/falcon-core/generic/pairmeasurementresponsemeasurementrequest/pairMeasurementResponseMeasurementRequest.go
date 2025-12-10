package pairmeasurementresponsemeasurementrequest

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/PairMeasurementResponseMeasurementRequest_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/messages/measurementrequest"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/messages/measurementresponse"
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
		C.PairMeasurementResponseMeasurementRequest_destroy(C.PairMeasurementResponseMeasurementRequestHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(first *measurementresponse.Handle, second *measurementrequest.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{first, second}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PairMeasurementResponseMeasurementRequest_create(C.MeasurementResponseHandle(first.CAPIHandle()), C.MeasurementRequestHandle(second.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PairMeasurementResponseMeasurementRequest_copy(C.PairMeasurementResponseMeasurementRequestHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) First() (*measurementresponse.Handle, error) {
	return cmemoryallocation.Read(h, func() (*measurementresponse.Handle, error) {

		return measurementresponse.FromCAPI(unsafe.Pointer(C.PairMeasurementResponseMeasurementRequest_first(C.PairMeasurementResponseMeasurementRequestHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Second() (*measurementrequest.Handle, error) {
	return cmemoryallocation.Read(h, func() (*measurementrequest.Handle, error) {

		return measurementrequest.FromCAPI(unsafe.Pointer(C.PairMeasurementResponseMeasurementRequest_second(C.PairMeasurementResponseMeasurementRequestHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.PairMeasurementResponseMeasurementRequest_equal(C.PairMeasurementResponseMeasurementRequestHandle(h.CAPIHandle()), C.PairMeasurementResponseMeasurementRequestHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.PairMeasurementResponseMeasurementRequest_not_equal(C.PairMeasurementResponseMeasurementRequestHandle(h.CAPIHandle()), C.PairMeasurementResponseMeasurementRequestHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.PairMeasurementResponseMeasurementRequest_to_json_string(C.PairMeasurementResponseMeasurementRequestHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.PairMeasurementResponseMeasurementRequest_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
