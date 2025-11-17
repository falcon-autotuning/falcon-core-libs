package time

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/Time_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type timeHandle C.TimeHandle

type Handle struct {
	thandle      timeHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

// CAPIHandle provides access to the underlying CAPI handle for the Time
func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.thandle == utils.NilHandle[timeHandle]() {
		return nil, errors.New(`CAPIHandle The time is closed`)
	}
	return unsafe.Pointer(h.thandle), nil
}

// new adds an auto cleanup whenever added to a constructor
func new(i timeHandle) *Handle {
	t := &Handle{thandle: i, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(t, func(_ any) { t.Close() }, true)
	return t
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`TimeFromCAPI The pointer is null`)
	}
	return new(timeHandle(p)), nil
}

// NewNow creates a new Time representing the current time
func NewNow() (*Handle, error) {
	h := timeHandle(C.Time_create_now())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

// NewAt creates a new Time at the given microseconds since epoch
func NewAt(microSecondsSinceEpoch int64) (*Handle, error) {
	h := timeHandle(C.Time_create_at(C.longlong(microSecondsSinceEpoch)))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.thandle != utils.NilHandle[timeHandle]() {
		C.Time_destroy(C.TimeHandle(h.thandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.thandle = utils.NilHandle[timeHandle]()
		return nil
	}
	return errors.New("unable to close the Time")
}

func (h *Handle) MicroSecondsSinceEpoch() (int64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.thandle == utils.NilHandle[timeHandle]() {
		return 0, errors.New(`MicroSecondsSinceEpoch The time is closed`)
	}
	val := int64(C.Time_micro_seconds_since_epoch(C.TimeHandle(h.thandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) Time() (int64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.thandle == utils.NilHandle[timeHandle]() {
		return 0, errors.New(`Time The time is closed`)
	}
	val := int64(C.Time_time(C.TimeHandle(h.thandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) ToString() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.thandle == utils.NilHandle[timeHandle]() {
		return "", errors.New(`ToString The time is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Time_to_string(C.TimeHandle(h.thandle))))
	if err != nil {
		return "", errors.New(`ToString could not convert to a String. ` + err.Error())
	}
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.thandle == utils.NilHandle[timeHandle]() {
		return false, errors.New(`Equal The time is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other time is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.thandle == utils.NilHandle[timeHandle]() {
		return false, errors.New(`Equal The other time is closed`)
	}
	val := bool(C.Time_equal(C.TimeHandle(h.thandle), C.TimeHandle(other.thandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.thandle == utils.NilHandle[timeHandle]() {
		return false, errors.New(`NotEqual The time is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other time is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.thandle == utils.NilHandle[timeHandle]() {
		return false, errors.New(`NotEqual The other time is closed`)
	}
	val := bool(C.Time_not_equal(C.TimeHandle(h.thandle), C.TimeHandle(other.thandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.thandle == utils.NilHandle[timeHandle]() {
		return "", errors.New(`ToJSON The time is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Time_to_json_string(C.TimeHandle(h.thandle))))
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
	h := timeHandle(C.Time_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
