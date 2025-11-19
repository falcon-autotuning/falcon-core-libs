package labelledcontrolarray

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
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
#include <falcon_core/math/arrays/LabelledControlArray_c_api.h>
#include <stdlib.h>
*/
import "C"

type chandle C.LabelledControlArrayHandle

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
		return nil, errors.New("CAPIHandle: LabelledControlArray is closed")
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
	h := chandle(C.LabelledControlArray_from_farray(C.FArrayDoubleHandle(faPtr), C.AcquisitionContextHandle(acPtr)))
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
	h := chandle(C.LabelledControlArray_from_control_array(C.ControlArrayHandle(maPtr), C.AcquisitionContextHandle(acPtr)))
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
	h := chandle(C.LabelledControlArray_from_json_string(C.StringHandle(capistr)))
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
		C.LabelledControlArray_destroy(C.LabelledControlArrayHandle(h.chandle))
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

func (h *Handle) Label() (*acquisitioncontext.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("Labels: LabelledControlArray is closed")
	}
	val := C.LabelledControlArray_label(C.LabelledControlArrayHandle(h.chandle))
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
		return nil, errors.New("Connection: LabelledControlArray is closed")
	}
	val := C.LabelledControlArray_connection(C.LabelledControlArrayHandle(h.chandle))
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
		return "", errors.New("InstrumentType: LabelledControlArray is closed")
	}
	val := C.LabelledControlArray_instrument_type(C.LabelledControlArrayHandle(h.chandle))
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
		return nil, errors.New("Units: LabelledControlArray is closed")
	}
	val := C.LabelledControlArray_units(C.LabelledControlArrayHandle(h.chandle))
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
		return 0, errors.New("Size: LabelledControlArray is closed")
	}
	val := int(C.LabelledControlArray_size(C.LabelledControlArrayHandle(h.chandle)))
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
		return 0, errors.New("Dimension: LabelledControlArray is closed")
	}
	val := int(C.LabelledControlArray_dimension(C.LabelledControlArrayHandle(h.chandle)))
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
		return nil, errors.New("Shape: LabelledControlArray is closed")
	}
	ndim := int(C.LabelledControlArray_dimension(C.LabelledControlArrayHandle(h.chandle)))
	out := make([]C.size_t, ndim)
	C.LabelledControlArray_shape(C.LabelledControlArrayHandle(h.chandle), &out[0], C.size_t(ndim))
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
		return nil, errors.New("Data: LabelledControlArray is closed")
	}
	size := int(C.LabelledControlArray_size(C.LabelledControlArrayHandle(h.chandle)))
	if size == 0 {
		return []float64{}, nil
	}
	out := make([]C.double, size)
	C.LabelledControlArray_data(C.LabelledControlArrayHandle(h.chandle), &out[0], C.size_t(size))
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
	C.LabelledControlArray_plusequals_farray(C.LabelledControlArrayHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_plusequals_double(C.LabelledControlArrayHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_plusequals_int(C.LabelledControlArrayHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusLabelledControlArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	if other == nil {
		return nil, errors.New("PlusLabelledControlArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("PlusLabelledControlArray: other is closed")
	}
	res := chandle(C.LabelledControlArray_plus_control_array(C.LabelledControlArrayHandle(h.chandle), C.LabelledControlArrayHandle(other.chandle)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	if other == nil {
		return nil, errors.New("PlusFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledControlArray_plus_farray(C.LabelledControlArrayHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_plus_double(C.LabelledControlArrayHandle(h.chandle), C.double(other)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_plus_int(C.LabelledControlArrayHandle(h.chandle), C.int(other)))
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
	C.LabelledControlArray_minusequals_farray(C.LabelledControlArrayHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_minusequals_double(C.LabelledControlArrayHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_minusequals_int(C.LabelledControlArrayHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusControlArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	if other == nil {
		return nil, errors.New("MinusLabelledControlArray: other is nil")
	}
	other.mu.RLock()
	other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray: other is closed")
	}
	res := chandle(C.LabelledControlArray_minus_control_array(C.LabelledControlArrayHandle(h.chandle), C.LabelledControlArrayHandle(other.chandle)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_minus_double(C.LabelledControlArrayHandle(h.chandle), C.double(other)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_minus_int(C.LabelledControlArrayHandle(h.chandle), C.int(other)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_negation(C.LabelledControlArrayHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_timesequals_double(C.LabelledControlArrayHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_timesequals_int(C.LabelledControlArrayHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_times_double(C.LabelledControlArrayHandle(h.chandle), C.double(other)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_times_int(C.LabelledControlArrayHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_dividesequals_double(C.LabelledControlArrayHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_dividesequals_int(C.LabelledControlArrayHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray: this is closed")
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_divides_int(C.LabelledControlArrayHandle(h.chandle), C.int(other)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_pow(C.LabelledControlArrayHandle(h.chandle), C.double(other)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_abs(C.LabelledControlArrayHandle(h.chandle)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	if other == nil {
		return nil, errors.New("MinFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledControlArray_min_farray(C.LabelledControlArrayHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinLabelledControlArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	if other == nil {
		return nil, errors.New("MinLabelledControlArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinLabelledControlArray: other is closed")
	}
	res := chandle(C.LabelledControlArray_min_control_array(C.LabelledControlArrayHandle(h.chandle), C.LabelledControlArrayHandle(other.chandle)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	if other == nil {
		return nil, errors.New("MaxFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledControlArray_max_farray(C.LabelledControlArrayHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	if other == nil {
		return nil, errors.New("MaxLabelledControlArray: other is nil")
	}
	if other == nil {
		return nil, errors.New("MaxControlArray: other is nil")
	}
	othercapi, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.LabelledControlArray_max_control_array(C.LabelledControlArrayHandle(h.chandle), C.LabelledControlArrayHandle(othercapi)))
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
		return false, errors.New("MinusLabelledControlArray: this is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.LabelledControlArray_equality(C.LabelledControlArrayHandle(h.chandle), C.LabelledControlArrayHandle(other.chandle)))
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
		return false, errors.New("MinusLabelledControlArray: this is closed")
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
		return false, errors.New("MinusLabelledControlArray: this is closed")
	}
	val := bool(C.LabelledControlArray_greaterthan(C.LabelledControlArrayHandle(h.chandle), C.double(value)))
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
		return false, errors.New("MinusLabelledControlArray: this is closed")
	}
	val := bool(C.LabelledControlArray_lessthan(C.LabelledControlArrayHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) RemoveOffset(offset float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.LabelledControlArray_remove_offset(C.LabelledControlArrayHandle(h.chandle), C.double(offset))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Sum() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("MinusLabelledControlArray: this is closed")
	}
	val := float64(C.LabelledControlArray_sum(C.LabelledControlArrayHandle(h.chandle)))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	res := chandle(C.LabelledControlArray_reshape(C.LabelledControlArrayHandle(h.chandle), &cshape[0], C.size_t(len(shape))))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := C.LabelledControlArray_where(C.LabelledControlArrayHandle(h.chandle), C.double(value))
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
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_flip(C.LabelledControlArrayHandle(h.chandle), C.size_t(axis)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) FullGradient() ([]*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	size := int(C.LabelledControlArray_dimension(C.LabelledControlArrayHandle(h.chandle)))
	out := make([]C.FArrayDoubleHandle, size)
	C.LabelledControlArray_full_gradient(C.LabelledControlArrayHandle(h.chandle), &out[0], C.size_t(size))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	res := make([]*farraydouble.Handle, size)
	for i := range out {
		res[i], err = farraydouble.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.New("FullGradient: could not convert gradient array to FArrayDouble: " + err.Error())
		}
	}
	return res, nil
}

func (h *Handle) Gradient(axis int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusLabelledControlArray: this is closed")
	}
	res := chandle(C.LabelledControlArray_gradient(C.LabelledControlArrayHandle(h.chandle), C.size_t(axis)))
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
		return 0, errors.New("MinusLabelledControlArray: this is closed")
	}
	val := float64(C.LabelledControlArray_get_sum_of_squares(C.LabelledControlArrayHandle(h.chandle)))
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
		return 0, errors.New("MinusLabelledControlArray: this is closed")
	}
	val := float64(C.LabelledControlArray_get_summed_diff_int_of_squares(C.LabelledControlArrayHandle(h.chandle), C.int(other)))
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
		return 0, errors.New("MinusLabelledControlArray: this is closed")
	}
	val := float64(C.LabelledControlArray_get_summed_diff_double_of_squares(C.LabelledControlArrayHandle(h.chandle), C.double(other)))
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
	val := float64(C.LabelledControlArray_get_summed_diff_array_of_squares(C.LabelledControlArrayHandle(h.chandle), C.LabelledControlArrayHandle(other.chandle)))
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
		return "", errors.New("ToJSON: LabelledControlArray is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.LabelledControlArray_to_json_string(C.LabelledControlArrayHandle(h.chandle))))
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
