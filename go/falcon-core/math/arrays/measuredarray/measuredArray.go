package measuredarray

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlistsizet"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/FArrayDouble_c_api.h>
#include <falcon_core/generic/ListListSizeT_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/arrays/MeasuredArray_c_api.h>
#include <stdlib.h>
*/
import "C"

type chandle C.MeasuredArrayHandle

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
		return nil, errors.New("CAPIHandle: MeasuredArray is closed")
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

func FromData(data []float64, shape []int) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	cdata := make([]C.double, len(data))
	for i, v := range data {
		cdata[i] = C.double(v)
	}
	h := chandle(C.MeasuredArray_from_data(&cdata[0], &cshape[0], C.size_t(len(shape))))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func FromFArray(fa *farraydouble.Handle) (*Handle, error) {
	if fa == nil {
		return nil, errors.New("FromFArray: input is nil")
	}
	faPtr, err := fa.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.MeasuredArray_from_farray(C.FArrayDoubleHandle(faPtr)))
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
	h := chandle(C.MeasuredArray_from_json_string(C.StringHandle(capistr)))
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
		C.MeasuredArray_destroy(C.MeasuredArrayHandle(h.chandle))
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

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("Size: MeasuredArray is closed")
	}
	val := int(C.MeasuredArray_size(C.MeasuredArrayHandle(h.chandle)))
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
		return 0, errors.New("Dimension: MeasuredArray is closed")
	}
	val := int(C.MeasuredArray_dimension(C.MeasuredArrayHandle(h.chandle)))
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
		return nil, errors.New("Shape: MeasuredArray is closed")
	}
	ndim := int(C.MeasuredArray_dimension(C.MeasuredArrayHandle(h.chandle)))
	out := make([]C.size_t, ndim)
	C.MeasuredArray_shape(C.MeasuredArrayHandle(h.chandle), &out[0], C.size_t(ndim))
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
		return nil, errors.New("Data: MeasuredArray is closed")
	}
	size := int(C.MeasuredArray_size(C.MeasuredArrayHandle(h.chandle)))
	out := make([]C.double, size)
	C.MeasuredArray_data(C.MeasuredArrayHandle(h.chandle), &out[0], C.size_t(size))
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
	C.MeasuredArray_plusequals_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_plusequals_double(C.MeasuredArrayHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_plusequals_int(C.MeasuredArrayHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusMeasuredArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("PlusMeasuredArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("PlusMeasuredArray: other is closed")
	}
	res := chandle(C.MeasuredArray_plus_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("PlusFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.MeasuredArray_plus_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_plus_double(C.MeasuredArrayHandle(h.chandle), C.double(other)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_plus_int(C.MeasuredArrayHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusEqualsFArray(other *farraydouble.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return errors.New("MinusEqualsFArray: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.MeasuredArray_minusequals_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_minusequals_double(C.MeasuredArrayHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_minusequals_int(C.MeasuredArrayHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusMeasuredArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("MinusMeasuredArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinusMeasuredArray: other is closed")
	}
	res := chandle(C.MeasuredArray_minus_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
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
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_minus_double(C.MeasuredArrayHandle(h.chandle), C.double(other)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_minus_int(C.MeasuredArrayHandle(h.chandle), C.int(other)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_negation(C.MeasuredArrayHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesEqualsMeasuredArray(other *Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return errors.New("TimesEqualsMeasuredArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return errors.New("TimesEqualsMeasuredArray: other is closed")
	}
	C.MeasuredArray_timesequals_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsFArray(other *farraydouble.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return errors.New("TimesEqualsMeasuredArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.MeasuredArray_timesequals_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(capifarray))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_timesequals_double(C.MeasuredArrayHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_timesequals_int(C.MeasuredArrayHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesMeasuredArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("TimesMeasuredArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("TimesMeasuredArray: other is closed")
	}
	res := chandle(C.MeasuredArray_times_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("TimesFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.MeasuredArray_times_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_times_double(C.MeasuredArrayHandle(h.chandle), C.double(other)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_times_int(C.MeasuredArrayHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesEqualsMeasuredArray(other *Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return errors.New("DividesEqualsMeasuredArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return errors.New("DividesEqualsMeasuredArray: other is closed")
	}
	C.MeasuredArray_dividesequals_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsFArray(other *farraydouble.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return errors.New("DividesEqualsFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.MeasuredArray_dividesequals_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(capifarray))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_dividesequals_double(C.MeasuredArrayHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_dividesequals_int(C.MeasuredArrayHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesMeasuredArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("DividesMeasuredArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("DividesMeasuredArray: other is closed")
	}
	res := chandle(C.MeasuredArray_divides_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesFArray(other *farraydouble.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("DividesFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.MeasuredArray_divides_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
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
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_divides_int(C.MeasuredArrayHandle(h.chandle), C.int(other)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_pow(C.MeasuredArrayHandle(h.chandle), C.double(other)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_abs(C.MeasuredArrayHandle(h.chandle)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("MinFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.MeasuredArray_min_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinMeasuredArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("MinMeasuredArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MinMeasuredArray: other is closed")
	}
	res := chandle(C.MeasuredArray_min_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("MaxFArray: other is nil")
	}
	capifarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.MeasuredArray_max_farray(C.MeasuredArrayHandle(h.chandle), C.FArrayDoubleHandle(capifarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MaxMeasuredArray(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return nil, errors.New("MaxMeasuredArray: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MaxMeasuredArray: other is closed")
	}
	res := chandle(C.MeasuredArray_max_measured_array(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.MeasuredArray_equality(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
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
		return false, errors.New("MeasuredArray is closed")
	}
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
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return false, errors.New("MeasuredArray is closed")
	}
	val := bool(C.MeasuredArray_greaterthan(C.MeasuredArrayHandle(h.chandle), C.double(value)))
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
		return false, errors.New("MeasuredArray is closed")
	}
	val := bool(C.MeasuredArray_lessthan(C.MeasuredArrayHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) RemoveOffset(offset float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return errors.New("MeasuredArray is closed")
	}
	C.MeasuredArray_remove_offset(C.MeasuredArrayHandle(h.chandle), C.double(offset))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Sum() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("MeasuredArray is closed")
	}
	val := float64(C.MeasuredArray_sum(C.MeasuredArrayHandle(h.chandle)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	res := chandle(C.MeasuredArray_reshape(C.MeasuredArrayHandle(h.chandle), &cshape[0], C.size_t(len(shape))))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Where(value float64) (*listlistsizet.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	res := C.MeasuredArray_where(C.MeasuredArrayHandle(h.chandle), C.double(value))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listlistsizet.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Flip(axis int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_flip(C.MeasuredArrayHandle(h.chandle), C.size_t(axis)))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	size := int(C.MeasuredArray_dimension(C.MeasuredArrayHandle(h.chandle)))
	out := make([]C.MeasuredArrayHandle, size)
	C.MeasuredArray_full_gradient(C.MeasuredArrayHandle(h.chandle), &out[0], C.size_t(size))
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
		return nil, errors.New("MeasuredArray is closed")
	}
	res := chandle(C.MeasuredArray_gradient(C.MeasuredArrayHandle(h.chandle), C.size_t(axis)))
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
		return 0, errors.New("MeasuredArray is closed")
	}
	val := float64(C.MeasuredArray_get_sum_of_squares(C.MeasuredArrayHandle(h.chandle)))
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
		return 0, errors.New("MeasuredArray is closed")
	}
	val := float64(C.MeasuredArray_get_summed_diff_int_of_squares(C.MeasuredArrayHandle(h.chandle), C.int(other)))
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
		return 0, errors.New("MeasuredArray is closed")
	}
	val := float64(C.MeasuredArray_get_summed_diff_double_of_squares(C.MeasuredArrayHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("MeasuredArray is closed")
	}
	if other == nil {
		return 0, errors.New("GetSummedDiffArrayOfSquares: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("GetSummedDiffArrayOfSquares: other is closed")
	}
	val := float64(C.MeasuredArray_get_summed_diff_array_of_squares(C.MeasuredArrayHandle(h.chandle), C.MeasuredArrayHandle(other.chandle)))
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
		return "", errors.New("ToJSON: MeasuredArray is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.MeasuredArray_to_json_string(C.MeasuredArrayHandle(h.chandle))))
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
