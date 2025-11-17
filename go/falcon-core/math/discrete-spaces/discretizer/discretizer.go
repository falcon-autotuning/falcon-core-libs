package discretizer

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/discrete_spaces/Discretizer_c_api.h>
#include <falcon_core/math/domains/Domain_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type discretizerHandle C.DiscretizerHandle

type Handle struct {
	chandle      discretizerHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

// CAPIHandle provides access to the underlying CAPI handle for the Discretizer
func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return nil, errors.New(`CAPIHandle The Discretizer is closed`)
	}
	return unsafe.Pointer(h.chandle), nil
}

// new adds an auto cleanup whenever added to a constructor
func new(i discretizerHandle) *Handle {
	d := &Handle{chandle: i, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(d, func(_ any) { d.Close() }, true)
	return d
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`DiscretizerFromCAPI The pointer is null`)
	}
	return new(discretizerHandle(p)), nil
}

// NewCartesian creates a new cartesian Discretizer
func NewCartesian(delta float64) (*Handle, error) {
	h := discretizerHandle(C.Discretizer_create_cartesian_discretizer(C.double(delta)))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

// NewPolar creates a new polar Discretizer
func NewPolar(delta float64) (*Handle, error) {
	h := discretizerHandle(C.Discretizer_create_polar_discretizer(C.double(delta)))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[discretizerHandle]() {
		C.Discretizer_destroy(C.DiscretizerHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[discretizerHandle]()
		return nil
	}
	return errors.New("unable to close the Discretizer")
}

func (h *Handle) Delta() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return 0, errors.New(`Delta The Discretizer is closed`)
	}
	val := float64(C.Discretizer_delta(C.DiscretizerHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) SetDelta(delta float64) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return errors.New(`SetDelta The Discretizer is closed`)
	}
	C.Discretizer_set_delta(C.DiscretizerHandle(h.chandle), C.double(delta))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Domain() (*domain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return nil, errors.New(`Domain The Discretizer is closed`)
	}
	dh := unsafe.Pointer(C.Discretizer_domain(C.DiscretizerHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return domain.FromCAPI(dh)
}

func (h *Handle) IsCartesian() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return false, errors.New(`IsCartesian The Discretizer is closed`)
	}
	val := bool(C.Discretizer_is_cartesian(C.DiscretizerHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsPolar() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return false, errors.New(`IsPolar The Discretizer is closed`)
	}
	val := bool(C.Discretizer_is_polar(C.DiscretizerHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return false, errors.New(`Equal The Discretizer is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other Discretizer is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[discretizerHandle]() {
		return false, errors.New(`Equal The other Discretizer is closed`)
	}
	val := bool(C.Discretizer_equal(C.DiscretizerHandle(h.chandle), C.DiscretizerHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return false, errors.New(`NotEqual The Discretizer is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other Discretizer is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[discretizerHandle]() {
		return false, errors.New(`NotEqual The other Discretizer is closed`)
	}
	val := bool(C.Discretizer_not_equal(C.DiscretizerHandle(h.chandle), C.DiscretizerHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discretizerHandle]() {
		return "", errors.New(`ToJSON The Discretizer is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Discretizer_to_json_string(C.DiscretizerHandle(h.chandle))))
	if err != nil {
		return "", errors.New(`ToJSON could not convert to a String. ` + err.Error())
	}
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New(`failed to access capi for json`), err)
	}
	h := discretizerHandle(C.Discretizer_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
