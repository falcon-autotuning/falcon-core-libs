package measurementrequest

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/messages/MeasurementRequest_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listwaveform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinstrumentportporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.MeasurementRequest_destroy(C.MeasurementRequestHandle(ptr))
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
				return unsafe.Pointer(C.MeasurementRequest_copy(C.MeasurementRequestHandle(handle.CAPIHandle()))), nil
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
		return bool(C.MeasurementRequest_equal(C.MeasurementRequestHandle(h.CAPIHandle()), C.MeasurementRequestHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MeasurementRequest_not_equal(C.MeasurementRequestHandle(h.CAPIHandle()), C.MeasurementRequestHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MeasurementRequest_to_json_string(C.MeasurementRequestHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MeasurementRequest_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(message string, measurement_name string, waveforms *listwaveform.Handle, getters *ports.Handle, meter_transforms *mapinstrumentportporttransform.Handle, time_domain *labelleddomain.Handle) (*Handle, error) {
	realmessage := str.New(message)
	realmeasurement_name := str.New(measurement_name)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realmessage, realmeasurement_name, waveforms, getters, meter_transforms, time_domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MeasurementRequest_create(C.StringHandle(realmessage.CAPIHandle()), C.StringHandle(realmeasurement_name.CAPIHandle()), C.ListWaveformHandle(waveforms.CAPIHandle()), C.PortsHandle(getters.CAPIHandle()), C.MapInstrumentPortPortTransformHandle(meter_transforms.CAPIHandle()), C.LabelledDomainHandle(time_domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) MeasurementName() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MeasurementRequest_measurement_name(C.MeasurementRequestHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("MeasurementName:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Getters() (*ports.Handle, error) {
	return cmemoryallocation.Read(h, func() (*ports.Handle, error) {

		return ports.FromCAPI(unsafe.Pointer(C.MeasurementRequest_getters(C.MeasurementRequestHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Waveforms() (*listwaveform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listwaveform.Handle, error) {

		return listwaveform.FromCAPI(unsafe.Pointer(C.MeasurementRequest_waveforms(C.MeasurementRequestHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) MeterTransforms() (*mapinstrumentportporttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapinstrumentportporttransform.Handle, error) {

		return mapinstrumentportporttransform.FromCAPI(unsafe.Pointer(C.MeasurementRequest_meter_transforms(C.MeasurementRequestHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) TimeDomain() (*labelleddomain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelleddomain.Handle, error) {

		return labelleddomain.FromCAPI(unsafe.Pointer(C.MeasurementRequest_time_domain(C.MeasurementRequestHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Message() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MeasurementRequest_message(C.MeasurementRequestHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Message:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
