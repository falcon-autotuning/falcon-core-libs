package measurementrequest

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListWaveform_c_api.h>
#include <falcon_core/generic/MapInstrumentPortPortTransform_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/names/Ports_c_api.h>
#include <falcon_core/math/domains/LabelledDomain_c_api.h>
#include <falcon_core/communications/messages/MeasurementRequest_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listwaveform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinstrumentportporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type measurementRequestHandle C.MeasurementRequestHandle

type Handle struct {
	chandle      measurementRequestHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(h measurementRequestHandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(handle, func(obj *Handle) { obj.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(measurementRequestHandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[measurementRequestHandle]() {
		C.MeasurementRequest_destroy(C.MeasurementRequestHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[measurementRequestHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

// Constructors

func New(message, measurementName string, waveforms *listwaveform.Handle, getters *ports.Handle, meterTransforms *mapinstrumentportporttransform.Handle, timeDomain *labelleddomain.Handle) (*Handle, error) {
	msgStr := str.New(message)
	defer msgStr.Close()
	if waveforms == nil {
		return nil, errors.New(`the waveforms are null`)
	}
	if getters == nil {
		return nil, errors.New(`the getters are null`)
	}
	if meterTransforms == nil {
		return nil, errors.New(`the meter transforms are null`)
	}
	if timeDomain == nil {
		return nil, errors.New(`teh time domain is null`)
	}
	msgPtr, err := msgStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	nameStr := str.New(measurementName)
	defer nameStr.Close()
	namePtr, err := nameStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	wavePtr, err := waveforms.CAPIHandle()
	if err != nil {
		return nil, err
	}
	getPtr, err := getters.CAPIHandle()
	if err != nil {
		return nil, err
	}
	meterPtr, err := meterTransforms.CAPIHandle()
	if err != nil {
		return nil, err
	}
	timePtr, err := timeDomain.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := measurementRequestHandle(C.MeasurementRequest_create(
		C.StringHandle(msgPtr),
		C.StringHandle(namePtr),
		C.ListWaveformHandle(wavePtr),
		C.PortsHandle(getPtr),
		C.MapInstrumentPortPortTransformHandle(meterPtr),
		C.LabelledDomainHandle(timePtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

// Methods

func (h *Handle) MeasurementName() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return "", errors.New("MeasurementName: handle is closed")
	}
	cStr := C.MeasurementRequest_measurement_name(C.MeasurementRequestHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return "", err
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func (h *Handle) Getters() (*ports.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return nil, errors.New("Getters: handle is closed")
	}
	cGet := C.MeasurementRequest_getters(C.MeasurementRequestHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return ports.FromCAPI(unsafe.Pointer(cGet))
}

func (h *Handle) Waveforms() (*listwaveform.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return nil, errors.New("Waveforms: handle is closed")
	}
	cWaves := C.MeasurementRequest_waveforms(C.MeasurementRequestHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listwaveform.FromCAPI(unsafe.Pointer(cWaves))
}

func (h *Handle) MeterTransforms() (*mapinstrumentportporttransform.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return nil, errors.New("MeterTransforms: handle is closed")
	}
	cMap := C.MeasurementRequest_meter_transforms(C.MeasurementRequestHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return mapinstrumentportporttransform.FromCAPI(unsafe.Pointer(cMap))
}

func (h *Handle) TimeDomain() (*labelleddomain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return nil, errors.New("TimeDomain: handle is closed")
	}
	cDom := C.MeasurementRequest_time_domain(C.MeasurementRequestHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return labelleddomain.FromCAPI(unsafe.Pointer(cDom))
}

func (h *Handle) Message() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return "", errors.New("Message: handle is closed")
	}
	cStr := C.MeasurementRequest_message(C.MeasurementRequestHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return "", err
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[measurementRequestHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.MeasurementRequest_equal(C.MeasurementRequestHandle(h.chandle), C.MeasurementRequestHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[measurementRequestHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.MeasurementRequest_not_equal(C.MeasurementRequestHandle(h.chandle), C.MeasurementRequestHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementRequestHandle]() {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.MeasurementRequest_to_json_string(C.MeasurementRequestHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return "", err
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := measurementRequestHandle(C.MeasurementRequest_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
