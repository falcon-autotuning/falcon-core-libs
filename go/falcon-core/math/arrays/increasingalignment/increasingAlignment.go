package increasingalignment

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/IncreasingAlignment_c_api.h>
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

type increasingAlignmentHandle C.IncreasingAlignmentHandle

type Handle struct {
	chandle      increasingAlignmentHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[increasingAlignmentHandle]() {
		return nil, errors.New(`CAPIHandle The IncreasingAlignment is closed`)
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(i increasingAlignmentHandle) *Handle {
	ia := &Handle{chandle: i, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(ia, func(_ any) { ia.Close() }, true)
	return ia
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`IncreasingAlignmentFromCAPI The pointer is null`)
	}
	return new(increasingAlignmentHandle(p)), nil
}

func NewEmpty() (*Handle, error) {
	h := increasingAlignmentHandle(C.IncreasingAlignment_create_empty())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func New(alignment bool) (*Handle, error) {
	h := increasingAlignmentHandle(C.IncreasingAlignment_create(C.bool(alignment)))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[increasingAlignmentHandle]() {
		C.IncreasingAlignment_destroy(C.IncreasingAlignmentHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[increasingAlignmentHandle]()
		return nil
	}
	return errors.New("unable to close the IncreasingAlignment")
}

func (h *Handle) Alignment() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[increasingAlignmentHandle]() {
		return 0, errors.New(`Alignment The IncreasingAlignment is closed`)
	}
	val := int(C.IncreasingAlignment_alignment(C.IncreasingAlignmentHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[increasingAlignmentHandle]() {
		return false, errors.New(`Equal The IncreasingAlignment is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other IncreasingAlignment is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[increasingAlignmentHandle]() {
		return false, errors.New(`Equal The other IncreasingAlignment is closed`)
	}
	val := bool(C.IncreasingAlignment_equal(C.IncreasingAlignmentHandle(h.chandle), C.IncreasingAlignmentHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[increasingAlignmentHandle]() {
		return false, errors.New(`NotEqual The IncreasingAlignment is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other IncreasingAlignment is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[increasingAlignmentHandle]() {
		return false, errors.New(`NotEqual The other IncreasingAlignment is closed`)
	}
	val := bool(C.IncreasingAlignment_not_equal(C.IncreasingAlignmentHandle(h.chandle), C.IncreasingAlignmentHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[increasingAlignmentHandle]() {
		return "", errors.New(`ToJSON The IncreasingAlignment is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.IncreasingAlignment_to_json_string(C.IncreasingAlignmentHandle(h.chandle))))
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
	h := increasingAlignmentHandle(C.IncreasingAlignment_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
