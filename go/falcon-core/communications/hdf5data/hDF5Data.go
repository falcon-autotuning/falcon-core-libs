package hdf5data

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/voltage_states/DeviceVoltageStates_c_api.h>
#include <falcon_core/generic/MapStringString_c_api.h>
#include <falcon_core/generic/PairMeasurementResponseMeasurementRequest_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/AxesControlArray_c_api.h>
#include <falcon_core/math/AxesCoupledLabelledDomain_c_api.h>
#include <falcon_core/math/AxesInt_c_api.h>
#include <falcon_core/math/arrays/LabelledArraysLabelledMeasuredArray_c_api.h>
#include <falcon_core/communications/HDF5Data_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/messages/measurementrequest"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/messages/measurementresponse"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringstring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairmeasurementresponsemeasurementrequest"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledarrayslabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type hdf5DataHandle C.HDF5DataHandle

type Handle struct {
	chandle      hdf5DataHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(h hdf5DataHandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(handle, func(obj *Handle) { obj.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(hdf5DataHandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[hdf5DataHandle]() {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[hdf5DataHandle]() {
		C.HDF5Data_destroy(C.HDF5DataHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[hdf5DataHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

// Constructors

func New(shape *axesint.Handle, unitDomain *axescontrolarray.Handle, domainLabels *axescoupledlabelleddomain.Handle, ranges *labelledarrayslabelledmeasuredarray.Handle, metadata *mapstringstring.Handle, measurementTitle string, uniqueID int, timestamp int) (*Handle, error) {
	shapePtr, err := shape.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitDomainPtr, err := unitDomain.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domainLabelsPtr, err := domainLabels.CAPIHandle()
	if err != nil {
		return nil, err
	}
	rangesPtr, err := ranges.CAPIHandle()
	if err != nil {
		return nil, err
	}
	metadataPtr, err := metadata.CAPIHandle()
	if err != nil {
		return nil, err
	}
	titleStr := str.New(measurementTitle)
	defer titleStr.Close()
	titlePtr, err := titleStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := hdf5DataHandle(C.HDF5Data_create(
		C.AxesIntHandle(shapePtr),
		C.AxesControlArrayHandle(unitDomainPtr),
		C.AxesCoupledLabelledDomainHandle(domainLabelsPtr),
		C.LabelledArraysLabelledMeasuredArrayHandle(rangesPtr),
		C.MapStringStringHandle(metadataPtr),
		C.StringHandle(titlePtr),
		C.int(uniqueID),
		C.int(timestamp),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromFile(path string) (*Handle, error) {
	pathStr := str.New(path)
	defer pathStr.Close()
	pathPtr, err := pathStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := hdf5DataHandle(C.HDF5Data_create_from_file(C.StringHandle(pathPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromCommunications(request *measurementrequest.Handle, response *measurementresponse.Handle, dvs *devicevoltagestates.Handle, sessionID [16]int8, measurementTitle string, uniqueID int, timestamp int) (*Handle, error) {
	reqPtr, err := request.CAPIHandle()
	if err != nil {
		return nil, err
	}
	respPtr, err := response.CAPIHandle()
	if err != nil {
		return nil, err
	}
	dvsPtr, err := dvs.CAPIHandle()
	if err != nil {
		return nil, err
	}
	titleStr := str.New(measurementTitle)
	defer titleStr.Close()
	titlePtr, err := titleStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	var sid [16]C.int8_t
	for i := 0; i < 16; i++ {
		sid[i] = C.int8_t(sessionID[i])
	}
	h := hdf5DataHandle(C.HDF5Data_create_from_communications(
		C.MeasurementRequestHandle(reqPtr),
		C.MeasurementResponseHandle(respPtr),
		C.DeviceVoltageStatesHandle(dvsPtr),
		(*C.int8_t)(&sid[0]),
		C.StringHandle(titlePtr),
		C.int(uniqueID),
		C.int(timestamp),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

// Methods

func (h *Handle) ToFile(path string) error {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[hdf5DataHandle]() {
		return errors.New("ToFile: handle is closed")
	}
	pathStr := str.New(path)
	defer pathStr.Close()
	pathPtr, err := pathStr.CAPIHandle()
	if err != nil {
		return err
	}
	C.HDF5Data_to_file(C.HDF5DataHandle(h.chandle), C.StringHandle(pathPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) ToCommunications() (*pairmeasurementresponsemeasurementrequest.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[hdf5DataHandle]() {
		return nil, errors.New("ToCommunications: handle is closed")
	}
	cPair := C.HDF5Data_to_communications(C.HDF5DataHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return pairmeasurementresponsemeasurementrequest.FromCAPI(unsafe.Pointer(cPair))
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[hdf5DataHandle]() {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[hdf5DataHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.HDF5Data_equal(C.HDF5DataHandle(h.chandle), C.HDF5DataHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[hdf5DataHandle]() {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[hdf5DataHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.HDF5Data_not_equal(C.HDF5DataHandle(h.chandle), C.HDF5DataHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[hdf5DataHandle]() {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.HDF5Data_to_json_string(C.HDF5DataHandle(h.chandle))
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
	h := hdf5DataHandle(C.HDF5Data_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
