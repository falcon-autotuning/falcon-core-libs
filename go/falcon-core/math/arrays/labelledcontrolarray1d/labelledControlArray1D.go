package labelledcontrolarray1d

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listfarraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/FArrayDouble_c_api.h>
#include <falcon_core/generic/ListListSizeT_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/arrays/ControlArray_c_api.h>
#include <falcon_core/math/arrays/LabelledControlArray1D_c_api.h>
#include <stdlib.h>
*/
import "C"

type chandle C.LabelledControlArray1DHandle

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
		return nil, errors.New("CAPIHandle: LabelledControlArray1D is closed")
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
	h := chandle(C.LabelledControlArray1D_from_farray(C.FArrayDoubleHandle(faPtr), C.AcquisitionContextHandle(acPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func FromControlArray(ma *controlarray.Handle, ac *acquisitioncontext.Handle) (*Handle, error) {
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
	h := chandle(C.LabelledControlArray1D_from_control_array(C.ControlArrayHandle(maPtr), C.AcquisitionContextHandle(acPtr)))
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
	h := chandle(C.LabelledControlArray1D_from_json_string(C.StringHandle(capistr)))
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
		C.LabelledControlArray1D_destroy(C.LabelledControlArray1DHandle(h.chandle))
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
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("LabelledControlArray1D is closed")
	}
	val := bool(C.LabelledControlArray1D_is_1D(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) As1D() (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("LabelledControlArray1D is closed")
	}
	res := C.LabelledControlArray1D_as_1D(C.LabelledControlArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetStart() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("LabelledControlArray1D is closed")
	}
	val := float64(C.LabelledControlArray1D_get_start(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetEnd() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("LabelledControlArray1D is closed")
	}
	val := float64(C.LabelledControlArray1D_get_end(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) IsDecreasing() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("LabelledControlArray1D is closed")
	}
	val := bool(C.LabelledControlArray1D_is_decreasing(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) IsIncreasing() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("LabelledControlArray1D is closed")
	}
	val := bool(C.LabelledControlArray1D_is_increasing(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) GetDistance() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("LabelledControlArray1D is closed")
	}
	val := float64(C.LabelledControlArray1D_get_distance(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetMean() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("LabelledControlArray1D is closed")
	}
	val := float64(C.LabelledControlArray1D_get_mean(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetStd() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("LabelledControlArray1D is closed")
	}
	val := float64(C.LabelledControlArray1D_get_std(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Reverse() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("LabelledControlArray1D is closed")
	}
	C.LabelledControlArray1D_reverse(C.LabelledControlArray1DHandle(h.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) GetClosestIndex(value float64) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("LabelledControlArray1D is closed")
	}
	val := int(C.LabelledControlArray1D_get_closest_index(C.LabelledControlArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) EvenDivisions(divisions int) (*listfarraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("LabelledControlArray1D is closed")
	}
	res := C.LabelledControlArray1D_even_divisions(C.LabelledControlArray1DHandle(h.chandle), C.size_t(divisions))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listfarraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Label() (*acquisitioncontext.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("Labels: LabelledControlArray1D is closed")
	}
	val := C.LabelledControlArray1D_label(C.LabelledControlArray1DHandle(h.chandle))
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
		return nil, errors.New("Connection: LabelledControlArray1D is closed")
	}
	val := C.LabelledControlArray1D_connection(C.LabelledControlArray1DHandle(h.chandle))
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
		return "", errors.New("InstrumentType: LabelledControlArray1D is closed")
	}
	val := C.LabelledControlArray1D_instrument_type(C.LabelledControlArray1DHandle(h.chandle))
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
		return nil, errors.New("Units: LabelledControlArray1D is closed")
	}
	val := C.LabelledControlArray1D_units(C.LabelledControlArray1DHandle(h.chandle))
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
		return 0, errors.New("Size: LabelledControlArray1D is closed")
	}
	val := int(C.LabelledControlArray1D_size(C.LabelledControlArray1DHandle(h.chandle)))
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
		return 0, errors.New("Dimension: LabelledControlArray1D is closed")
	}
	val := int(C.LabelledControlArray1D_dimension(C.LabelledControlArray1DHandle(h.chandle)))
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
		return nil, errors.New("Shape: LabelledControlArray1D is closed")
	}
	ndim := int(C.LabelledControlArray1D_dimension(C.LabelledControlArray1DHandle(h.chandle)))
	out := make([]C.size_t, ndim)
	C.LabelledControlArray1D_shape(C.LabelledControlArray1DHandle(h.chandle), &out[0], C.size_t(ndim))
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
		return nil, errors.New("Data: LabelledControlArray1D is closed")
	}
	size := int(C.LabelledControlArray1D_size(C.LabelledControlArray1DHandle(h.chandle)))
	if size == 0 {
		return []float64{}, nil
	}
	out := make([]C.double, size)
	C.LabelledControlArray1D_data(C.LabelledControlArray1DHandle(h.chandle), &out[0], C.size_t(size))
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
	C.LabelledControlArray1D_plusequals_farray(C.LabelledControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_plusequals_double(C.LabelledControlArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_plusequals_int(C.LabelledControlArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusLabelledControlArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return nil, errors.New("PlusLabelledControlArray1D: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("PlusLabelledControlArray1D: other is closed")
	}
	res := chandle(C.LabelledControlArray1D_plus_control_array(C.LabelledControlArray1DHandle(h.chandle), C.LabelledControlArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PlusFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return nil, errors.New("PlusFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledControlArray1D_plus_farray(C.LabelledControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_plus_double(C.LabelledControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PlusInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_plus_int(C.LabelledControlArray1DHandle(h.chandle), C.int(other)))
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
	C.LabelledControlArray1D_minusequals_farray(C.LabelledControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_minusequals_double(C.LabelledControlArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_minusequals_int(C.LabelledControlArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusControlArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return nil, errors.New("MinusLabelledControlArray1D: other is nil")
	}
	other.mu.RLock()
	other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: other is closed")
	}
	res := chandle(C.LabelledControlArray1D_minus_control_array(C.LabelledControlArray1DHandle(h.chandle), C.LabelledControlArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return nil, errors.New("MinusFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.ControlArray_minus_farray(C.ControlArrayHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_minus_double(C.LabelledControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_minus_int(C.LabelledControlArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Negation() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_negation(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_timesequals_double(C.LabelledControlArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_timesequals_int(C.LabelledControlArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_times_double(C.LabelledControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_times_int(C.LabelledControlArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_dividesequals_double(C.LabelledControlArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_dividesequals_int(C.LabelledControlArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.ControlArray_divides_double(C.ControlArrayHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_divides_int(C.LabelledControlArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Pow(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_pow(C.LabelledControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Abs() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_abs(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return nil, errors.New("MinFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledControlArray1D_min_farray(C.LabelledControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinLabelledControlArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return nil, errors.New("MinLabelledControlArray1D: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinLabelledControlArray1D: other is closed")
	}
	res := chandle(C.LabelledControlArray1D_min_control_array(C.LabelledControlArray1DHandle(h.chandle), C.LabelledControlArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MaxFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return nil, errors.New("MaxFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledControlArray1D_max_farray(C.LabelledControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MaxControlArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return nil, errors.New("MaxLabelledControlArray1D: other is nil")
	}
	if other == nil {
		return nil, errors.New("MaxControlArray: other is nil")
	}
	othercapi, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledControlArray1D_max_control_array(C.LabelledControlArray1DHandle(h.chandle), C.LabelledControlArray1DHandle(othercapi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.LabelledControlArray1D_equality(C.LabelledControlArray1DHandle(h.chandle), C.LabelledControlArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.ControlArray_notequality(C.ControlArrayHandle(h.chandle), C.ControlArrayHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) GreaterThan(value float64) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	val := bool(C.LabelledControlArray1D_greaterthan(C.LabelledControlArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) LessThan(value float64) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	val := bool(C.LabelledControlArray1D_lessthan(C.LabelledControlArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) RemoveOffset(offset float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray1D_remove_offset(C.LabelledControlArray1DHandle(h.chandle), C.double(offset))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Sum() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	val := float64(C.LabelledControlArray1D_sum(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Reshape(shape []int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	res := chandle(C.LabelledControlArray1D_reshape(C.LabelledControlArray1DHandle(h.chandle), &cshape[0], C.size_t(len(shape))))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Where(value float64) (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := C.LabelledControlArray1D_where(C.LabelledControlArray1DHandle(h.chandle), C.double(value))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return unsafe.Pointer(res), nil
}

func (h *Handle) Flip(axis int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_flip(C.LabelledControlArray1DHandle(h.chandle), C.size_t(axis)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) FullGradient() ([]*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	size := int(C.LabelledControlArray1D_dimension(C.LabelledControlArray1DHandle(h.chandle)))
	out := make([]C.FArrayDoubleHandle, size)
	C.LabelledControlArray1D_full_gradient(C.LabelledControlArray1DHandle(h.chandle), &out[0], C.size_t(size))
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
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	res := chandle(C.LabelledControlArray1D_gradient(C.LabelledControlArray1DHandle(h.chandle), C.size_t(axis)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) GetSumOfSquares() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	val := float64(C.LabelledControlArray1D_get_sum_of_squares(C.LabelledControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetSummedDiffIntOfSquares(other int) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	val := float64(C.LabelledControlArray1D_get_summed_diff_int_of_squares(C.LabelledControlArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("MinusLabelledControlArray1D: this is closed")
	}
	val := float64(C.LabelledControlArray1D_get_summed_diff_double_of_squares(C.LabelledControlArray1DHandle(h.chandle), C.double(other)))
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
	val := float64(C.LabelledControlArray1D_get_summed_diff_array_of_squares(C.LabelledControlArray1DHandle(h.chandle), C.LabelledControlArray1DHandle(other.chandle)))
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
		return "", errors.New("ToJSON: LabelledControlArray1D is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_to_json_string(C.LabelledControlArray1DHandle(h.chandle))))
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
