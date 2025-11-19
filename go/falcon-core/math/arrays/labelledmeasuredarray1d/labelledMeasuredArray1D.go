package labelledmeasuredarray1d

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/measuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/FArrayDouble_c_api.h>
#include <falcon_core/generic/ListListSizeT_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/arrays/MeasuredArray_c_api.h>
#include <falcon_core/math/arrays/LabelledMeasuredArray1D_c_api.h>
#include <stdlib.h>
*/
import "C"

type chandle C.LabelledMeasuredArray1DHandle

type Handle struct {
	chandle      chandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("CAPIHandle: LabelledMeasuredArray1D is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(h chandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(handle, func(_ any) { handle.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is null")
	}
	return new(chandle(p)), nil
}

func FromFArray(fa *farraydouble.Handle, ac *acquisitioncontext.Handle) (*Handle, error) {
	if fa == nil {
		return nil, errors.New("FromFArray: input is nil")
	}
	faPtr, err := fa.CAPIHandle()
	if err != nil {
		return nil, err
	}
	acPtr, err := ac.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.LabelledMeasuredArray1D_from_farray(C.FArrayDoubleHandle(faPtr), C.AcquisitionContextHandle(acPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func FromMeasuredArray(ma *measuredarray.Handle, ac *acquisitioncontext.Handle) (*Handle, error) {
	if ma == nil {
		return nil, errors.New("FromFArray: input is nil")
	}
	maPtr, err := ma.CAPIHandle()
	if err != nil {
		return nil, err
	}
	acPtr, err := ac.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.LabelledMeasuredArray1D_from_measured_array(C.MeasuredArrayHandle(maPtr), C.AcquisitionContextHandle(acPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("failed to access capi for json"), err)
	}
	h := chandle(C.LabelledMeasuredArray1D_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[chandle]() {
		C.LabelledMeasuredArray1D_destroy(C.LabelledMeasuredArray1DHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[chandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

func (h *Handle) Is1D() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.LabelledMeasuredArray1D_is_1D(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) As1D() (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.LabelledMeasuredArray1D_as_1D(C.LabelledMeasuredArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetStart() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_get_start(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetEnd() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_get_end(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) IsDecreasing() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.LabelledMeasuredArray1D_is_decreasing(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) IsIncreasing() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.LabelledMeasuredArray1D_is_increasing(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) GetDistance() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_get_distance(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetMean() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_get_mean(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetStd() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_get_std(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Reverse() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_reverse(C.LabelledMeasuredArray1DHandle(h.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) GetClosestIndex(value float64) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := int(C.LabelledMeasuredArray1D_get_closest_index(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) EvenDivisions(divisions int) (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.LabelledMeasuredArray1D_even_divisions(C.LabelledMeasuredArray1DHandle(h.chandle), C.size_t(divisions))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return unsafe.Pointer(res), nil
}

func (h *Handle) Label() (*acquisitioncontext.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("Labels: LabelledMeasuredArray1D is closed")
	}
	val := C.LabelledMeasuredArray1D_label(C.LabelledMeasuredArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return acquisitioncontext.FromCAPI(unsafe.Pointer(val))
}

func (h *Handle) Connection() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("Connection: LabelledMeasuredArray1D is closed")
	}
	val := C.LabelledMeasuredArray1D_connection(C.LabelledMeasuredArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(val))
}

func (h *Handle) InstrumentType() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return "", errors.New("InstrumentType: LabelledMeasuredArray1D is closed")
	}
	val := C.LabelledMeasuredArray1D_instrument_type(C.LabelledMeasuredArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return "", err
	}
	hstr, err := str.FromCAPI(unsafe.Pointer(val))
	if err != nil {
		return "", err
	}
	return hstr.ToGoString()
}

func (h *Handle) Units() (*symbolunit.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("Units: LabelledMeasuredArray1D is closed")
	}
	val := C.LabelledMeasuredArray1D_units(C.LabelledMeasuredArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return symbolunit.FromCAPI(unsafe.Pointer(val))
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("Size: LabelledMeasuredArray1D is closed")
	}
	val := int(C.LabelledMeasuredArray1D_size(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Dimension() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("Dimension: LabelledMeasuredArray1D is closed")
	}
	val := int(C.LabelledMeasuredArray1D_dimension(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Shape() ([]int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("Shape: LabelledMeasuredArray1D is closed")
	}
	ndim := int(C.LabelledMeasuredArray1D_dimension(C.LabelledMeasuredArray1DHandle(h.chandle)))
	out := make([]C.size_t, ndim)
	C.LabelledMeasuredArray1D_shape(C.LabelledMeasuredArray1DHandle(h.chandle), &out[0], C.size_t(ndim))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	shape := make([]int, ndim)
	for i := range out {
		shape[i] = int(out[i])
	}
	return shape, nil
}

func (h *Handle) Data() ([]float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("Data: LabelledMeasuredArray1D is closed")
	}
	size := int(C.LabelledMeasuredArray1D_size(C.LabelledMeasuredArray1DHandle(h.chandle)))
	if size == 0 {
		return []float64{}, nil
	}
	out := make([]C.double, size)
	C.LabelledMeasuredArray1D_data(C.LabelledMeasuredArray1DHandle(h.chandle), &out[0], C.size_t(size))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	data := make([]float64, size)
	for i := range out {
		data[i] = float64(out[i])
	}
	return data, nil
}

// Arithmetic and assignment

func (h *Handle) PlusEqualsFArray(other *farraydouble.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if other == nil {
		return errors.New("PlusEqualsFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.LabelledMeasuredArray1D_plusequals_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_plusequals_double(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_plusequals_int(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusLabelledMeasuredArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("PlusLabelledMeasuredArray1D: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("PlusLabelledMeasuredArray1D: other is closed")
	}
	res := chandle(C.LabelledMeasuredArray1D_plus_measured_array(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PlusFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("PlusFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledMeasuredArray1D_plus_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_plus_double(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PlusInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_plus_int(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusEqualsFArray(other *farraydouble.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if other == nil {
		return errors.New("MinusEqualsFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.LabelledMeasuredArray1D_minusequals_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_minusequals_double(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_minusequals_int(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusMeasuredArray(other *measuredarray.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MinusLabelledMeasuredArray1D: other is nil")
	}
	if other == nil {
		return nil, errors.New("MaxMeasuredArray: other is nil")
	}
	othercapi, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledMeasuredArray1D_minus_measured_array(C.LabelledMeasuredArray1DHandle(h.chandle), C.MeasuredArrayHandle(othercapi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MinusFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.MeasuredArray_minus_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_minus_double(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_minus_int(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Negation() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_negation(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesEqualsLabelledMeasuredArray1D(other *Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if other == nil {
		return errors.New("TimesEqualsLabelledMeasuredArray1D: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return errors.New("TimesEqualsLabelledMeasuredArray1D: other is closed")
	}
	C.LabelledMeasuredArray1D_timesequals_measured_array(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(other.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsFArray(other *farraydouble.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if other == nil {
		return errors.New("TimesEqualsLabelledMeasuredArray1D: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.LabelledMeasuredArray1D_timesequals_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(capifarray))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_timesequals_double(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_timesequals_int(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesLabelledMeasuredArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("TimesLabelledMeasuredArray1D: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("TimesLabelledMeasuredArray1D: other is closed")
	}
	res := chandle(C.LabelledMeasuredArray1D_times_measured_array(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("TimesFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledMeasuredArray1D_times_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_times_double(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_times_int(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesEqualsLabelledMeasuredArray1D(other *Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if other == nil {
		return errors.New("DividesEqualsLabelledMeasuredArray1D: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return errors.New("DividesEqualsLabelledMeasuredArray1D: other is closed")
	}
	capimarray, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.LabelledMeasuredArray1D_dividesequals_measured_array(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(capimarray))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsFArray(other *farraydouble.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if other == nil {
		return errors.New("DividesEqualsFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.LabelledMeasuredArray1D_dividesequals_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(capifarray))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_dividesequals_double(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_dividesequals_int(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesLabelledMeasuredArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("DividesLabelledMeasuredArray1D: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("DividesLabelledMeasuredArray1D: other is closed")
	}
	capimarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledMeasuredArray1D_divides_measured_array(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(capimarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("DividesFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledMeasuredArray1D_divides_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.MeasuredArray_divides_double(C.MeasuredArrayHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_divides_int(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Pow(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_pow(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Abs() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_abs(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MinFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledMeasuredArray1D_min_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinLabelledMeasuredArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MinLabelledMeasuredArray1D: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinLabelledMeasuredArray1D: other is closed")
	}
	res := chandle(C.LabelledMeasuredArray1D_min_measured_array(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MaxFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MaxFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledMeasuredArray1D_max_farray(C.LabelledMeasuredArray1DHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MaxMeasuredArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MaxLabelledMeasuredArray1D: other is nil")
	}
	if other == nil {
		return nil, errors.New("MaxMeasuredArray: other is nil")
	}
	othercapi, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledMeasuredArray1D_max_measured_array(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(othercapi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.LabelledMeasuredArray1D_equality(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.MeasuredArray_notequality(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) GreaterThan(value float64) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.LabelledMeasuredArray1D_greaterthan(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) LessThan(value float64) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.LabelledMeasuredArray1D_lessthan(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) RemoveOffset(offset float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledMeasuredArray1D_remove_offset(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(offset))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Sum() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_sum(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Reshape(shape []int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	res := chandle(C.LabelledMeasuredArray1D_reshape(C.LabelledMeasuredArray1DHandle(h.chandle), &cshape[0], C.size_t(len(shape))))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Where(value float64) (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.LabelledMeasuredArray1D_where(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(value))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return unsafe.Pointer(res), nil
}

func (h *Handle) Flip(axis int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_flip(C.LabelledMeasuredArray1DHandle(h.chandle), C.size_t(axis)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) FullGradient() ([]*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	size := int(C.LabelledMeasuredArray1D_dimension(C.LabelledMeasuredArray1DHandle(h.chandle)))
	out := make([]C.LabelledMeasuredArray1DHandle, size)
	C.LabelledMeasuredArray1D_full_gradient(C.LabelledMeasuredArray1DHandle(h.chandle), &out[0], C.size_t(size))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	res := make([]*Handle, size)
	for i := range out {
		res[i] = new(chandle(out[i]))
	}
	return res, nil
}

func (h *Handle) Gradient(axis int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.LabelledMeasuredArray1D_gradient(C.LabelledMeasuredArray1DHandle(h.chandle), C.size_t(axis)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) GetSumOfSquares() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_get_sum_of_squares(C.LabelledMeasuredArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetSummedDiffIntOfSquares(other int) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_get_summed_diff_int_of_squares(C.LabelledMeasuredArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.LabelledMeasuredArray1D_get_summed_diff_double_of_squares(C.LabelledMeasuredArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return 0, errors.New("GetSummedDiffArrayOfSquares: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("GetSummedDiffArrayOfSquares: other is closed")
	}
	val := float64(C.LabelledMeasuredArray1D_get_summed_diff_array_of_squares(C.LabelledMeasuredArray1DHandle(h.chandle), C.LabelledMeasuredArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return "", errors.New("ToJSON: LabelledMeasuredArray1D is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_to_json_string(C.LabelledMeasuredArray1DHandle(h.chandle))))
	if err != nil {
		return "", errors.New("ToJSON could not convert to a String. " + err.Error())
	}
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}
