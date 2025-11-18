package controlarray1d

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/ControlArray1D_c_api.h>
#include <falcon_core/generic/FArrayDouble_c_api.h>
#include <falcon_core/generic/ListListSizeT_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

type chandle C.ControlArray1DHandle

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
		return nil, errors.New("CAPIHandle: ControlArray1D is closed")
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
	h := chandle(C.ControlArray1D_from_data(&cdata[0], &cshape[0], C.size_t(len(shape))))
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
	h := chandle(C.ControlArray1D_from_farray(C.FArrayDoubleHandle(faPtr)))
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
	h := chandle(C.ControlArray1D_from_json_string(C.StringHandle(capistr)))
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
		C.ControlArray1D_destroy(C.ControlArray1DHandle(h.chandle))
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
	val := bool(C.ControlArray1D_is_1D(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) As1D() (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.ControlArray1D_as_1D(C.ControlArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetStart() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_get_start(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetEnd() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_get_end(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) IsDecreasing() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.ControlArray1D_is_decreasing(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) IsIncreasing() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.ControlArray1D_is_increasing(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) GetDistance() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_get_distance(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetMean() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_get_mean(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetStd() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_get_std(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Reverse() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_reverse(C.ControlArray1DHandle(h.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) GetClosestIndex(value float64) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := int(C.ControlArray1D_get_closest_index(C.ControlArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) EvenDivisions(divisions int) (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.ControlArray1D_even_divisions(C.ControlArray1DHandle(h.chandle), C.size_t(divisions))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return unsafe.Pointer(res), nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return 0, errors.New("Size: ControlArray1D is closed")
	}
	val := int(C.ControlArray1D_size(C.ControlArray1DHandle(h.chandle)))
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
		return 0, errors.New("Dimension: ControlArray1D is closed")
	}
	val := int(C.ControlArray1D_dimension(C.ControlArray1DHandle(h.chandle)))
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
		return nil, errors.New("Shape: ControlArray1D is closed")
	}
	ndim := int(C.ControlArray1D_dimension(C.ControlArray1DHandle(h.chandle)))
	out := make([]C.size_t, ndim)
	C.ControlArray1D_shape(C.ControlArray1DHandle(h.chandle), &out[0], C.size_t(ndim))
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
		return nil, errors.New("Data: ControlArray1D is closed")
	}
	size := int(C.ControlArray1D_size(C.ControlArray1DHandle(h.chandle)))
	out := make([]C.double, size)
	C.ControlArray1D_data(C.ControlArray1DHandle(h.chandle), &out[0], C.size_t(size))
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
	C.ControlArray1D_plusequals_farray(C.ControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_plusequals_double(C.ControlArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_plusequals_int(C.ControlArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) PlusControlArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("PlusControlArray1D: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.ControlArray1D_plus_control_array(C.ControlArray1DHandle(h.chandle), C.ControlArray1DHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
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
	res := chandle(C.ControlArray1D_plus_farray(C.ControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_plus_double(C.ControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PlusInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_plus_int(C.ControlArray1DHandle(h.chandle), C.int(other)))
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
	C.ControlArray1D_minusequals_farray(C.ControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_minusequals_double(C.ControlArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_minusequals_int(C.ControlArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MinusControlArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MinusControlArray1D: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.ControlArray1D_minus_control_array(C.ControlArray1DHandle(h.chandle), C.ControlArray1DHandle(otherPtr)))
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
	res := chandle(C.ControlArray1D_minus_farray(C.ControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_minus_double(C.ControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinusInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_minus_int(C.ControlArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Negation() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_negation(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_timesequals_double(C.ControlArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_timesequals_int(C.ControlArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_times_double(C.ControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TimesInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_times_int(C.ControlArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesEqualsDouble(other float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_dividesequals_double(C.ControlArray1DHandle(h.chandle), C.double(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesEqualsInt(other int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_dividesequals_int(C.ControlArray1DHandle(h.chandle), C.int(other))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_divides_double(C.ControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DividesInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_divides_int(C.ControlArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Pow(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_pow(C.ControlArray1DHandle(h.chandle), C.double(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Abs() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_abs(C.ControlArray1DHandle(h.chandle)))
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
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.ControlArray1D_min_farray(C.ControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MinControlArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MinControlArray1D: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.ControlArray1D_min_control_array(C.ControlArray1DHandle(h.chandle), C.ControlArray1DHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
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
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.ControlArray1D_max_farray(C.ControlArray1DHandle(h.chandle), C.FArrayDoubleHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) MaxControlArray1D(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("MaxControlArray1D: other is nil")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.ControlArray1D_max_control_array(C.ControlArray1DHandle(h.chandle), C.ControlArray1DHandle(otherPtr)))
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
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.ControlArray1D_equality(C.ControlArray1DHandle(h.chandle), C.ControlArray1DHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
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
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.ControlArray1D_notequality(C.ControlArray1DHandle(h.chandle), C.ControlArray1DHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) GreaterThan(value float64) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.ControlArray1D_greaterthan(C.ControlArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) LessThan(value float64) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.ControlArray1D_lessthan(C.ControlArray1DHandle(h.chandle), C.double(value)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) RemoveOffset(offset float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.ControlArray1D_remove_offset(C.ControlArray1DHandle(h.chandle), C.double(offset))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Sum() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_sum(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Where(value float64) (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.ControlArray1D_where(C.ControlArray1DHandle(h.chandle), C.double(value))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return unsafe.Pointer(res), nil
}

func (h *Handle) Flip(axis int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.ControlArray1D_flip(C.ControlArray1DHandle(h.chandle), C.size_t(axis)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) FullGradient() ([]*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	size := int(C.ControlArray1D_dimension(C.ControlArray1DHandle(h.chandle)))
	out := make([]C.FArrayDoubleHandle, size)
	C.ControlArray1D_full_gradient(C.ControlArray1DHandle(h.chandle), &out[0], C.size_t(size))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	res := make([]*farraydouble.Handle, size)
	for i := range out {
		res[i], _ = farraydouble.FromCAPI(unsafe.Pointer(out[i]))
	}
	return res, nil
}

func (h *Handle) Gradient(axis int) (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.ControlArray1D_gradient(C.ControlArray1DHandle(h.chandle), C.size_t(axis))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetSumOfSquares() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_get_sum_of_squares(C.ControlArray1DHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetSummedDiffIntOfSquares(other int) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_get_summed_diff_int_of_squares(C.ControlArray1DHandle(h.chandle), C.int(other)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := float64(C.ControlArray1D_get_summed_diff_double_of_squares(C.ControlArray1DHandle(h.chandle), C.double(other)))
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
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return 0, err
	}
	val := float64(C.ControlArray1D_get_summed_diff_array_of_squares(C.ControlArray1DHandle(h.chandle), C.ControlArray1DHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return "", errors.New("ToJSON: ControlArray1D is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.ControlArray1D_to_json_string(C.ControlArray1DHandle(h.chandle))))
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
