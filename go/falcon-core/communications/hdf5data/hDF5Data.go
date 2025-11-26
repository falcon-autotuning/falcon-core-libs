package hdf5data

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/HDF5Data_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringstring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairmeasurementresponsemeasurementrequest"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledarrayslabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.HDF5Data_destroy(C.HDF5DataHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(shape *axesint.Handle, unit_domain *axescontrolarray.Handle, domain_labels *axescoupledlabelleddomain.Handle, ranges *labelledarrayslabelledmeasuredarray.Handle, metadata *mapstringstring.Handle, measurement_title string, unique_id int32, timestamp int32) (*Handle, error) {
	realmeasurement_title := str.New(measurement_title)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{shape, unit_domain, domain_labels, ranges, metadata, realmeasurement_title}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.HDF5Data_create(C.AxesIntHandle(shape.CAPIHandle()), C.AxesControlArrayHandle(unit_domain.CAPIHandle()), C.AxesCoupledLabelledDomainHandle(domain_labels.CAPIHandle()), C.LabelledArraysLabelledMeasuredArrayHandle(ranges.CAPIHandle()), C.MapStringStringHandle(metadata.CAPIHandle()), C.StringHandle(realmeasurement_title.CAPIHandle()), C.int(unique_id), C.int(timestamp))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromFile(path string) (*Handle, error) {
	realpath := str.New(path)
	return cmemoryallocation.Read(realpath, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.HDF5Data_create_from_file(C.StringHandle(realpath.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromCommunications(request *measurementrequest.Handle, response *measurementresponse.Handle, device_voltage_states *devicevoltagestates.Handle, session_id int8, measurement_title string, unique_id int32, timestamp int32) (*Handle, error) {
	realmeasurement_title := str.New(measurement_title)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{request, response, device_voltage_states, realmeasurement_title}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.HDF5Data_create_from_communications(C.MeasurementRequestHandle(request.CAPIHandle()), C.MeasurementResponseHandle(response.CAPIHandle()), C.DeviceVoltageStatesHandle(device_voltage_states.CAPIHandle()), C.int8_t(session_id), C.StringHandle(realmeasurement_title.CAPIHandle()), C.int(unique_id), C.int(timestamp))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) ToFile(path string) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{path}, func() error {
		C.HDF5Data_to_file(C.HDF5DataHandle(h.CAPIHandle()), C.StringHandle(path.CAPIHandle()))
		return nil
	})
}
func (h *Handle) ToCommunications() (*pairmeasurementresponsemeasurementrequest.Handle, error) {
	return cmemoryallocation.Read(h, func() (*pairmeasurementresponsemeasurementrequest.Handle, error) {

		return pairmeasurementresponsemeasurementrequest.FromCAPI(unsafe.Pointer(C.HDF5Data_to_communications(C.HDF5DataHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.HDF5Data_equal(C.HDF5DataHandle(h.CAPIHandle()), C.HDF5DataHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.HDF5Data_not_equal(C.HDF5DataHandle(h.CAPIHandle()), C.HDF5DataHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.HDF5Data_to_json_string(C.HDF5DataHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.HDF5Data_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
