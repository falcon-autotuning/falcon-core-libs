package standardrequest

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/messages/StandardRequest_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorHandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type standardRequestHandle C.StandardRequestHandle

type Handle struct {
	chandle      standardRequestHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorHandling.Handle
}

// CAPIHandle provides access to the underlying CAPI handle for the StandardRequest
func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[standardRequestHandle]() {
		return nil, errors.New(`CAPIHandle The StandardRequest is closed`)
	}
	return unsafe.Pointer(h.chandle), nil
}

// new adds an auto cleanup whenever added to a constructor
func new(i standardRequestHandle) *Handle {
	sr := &Handle{chandle: i, errorHandler: errorHandling.ErrorHandler}
	runtime.AddCleanup(sr, func(_ any) { sr.Close() }, true)
	return sr
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`StandardRequestFromCAPI The pointer is null`)
	}
	return new(standardRequestHandle(p)), nil
}

// New creates a new StandardRequest from a message string
func New(message string) (*Handle, error) {
	strHandle := str.New(message)
	defer strHandle.Close()
	capistr, err := strHandle.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New construction failed from illegal string"), err)
	}
	h := standardRequestHandle(C.StandardRequest_create(C.StringHandle(capistr)))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[standardRequestHandle]() {
		C.StandardRequest_destroy(C.StandardRequestHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[standardRequestHandle]()
		return nil
	}
	return errors.New("unable to close the StandardRequest")
}

func (h *Handle) Message() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[standardRequestHandle]() {
		return "", errors.New(`Message The StandardRequest is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.StandardRequest_message(C.StandardRequestHandle(h.chandle))))
	if err != nil {
		return "", errors.New(`Message could not convert to a String. ` + err.Error())
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
	if h.closed || h.chandle == utils.NilHandle[standardRequestHandle]() {
		return false, errors.New(`Equal The StandardRequest is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other StandardRequest is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[standardRequestHandle]() {
		return false, errors.New(`Equal The other StandardRequest is closed`)
	}
	val := bool(C.StandardRequest_equal(C.StandardRequestHandle(h.chandle), C.StandardRequestHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[standardRequestHandle]() {
		return false, errors.New(`NotEqual The StandardRequest is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other StandardRequest is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[standardRequestHandle]() {
		return false, errors.New(`NotEqual The other StandardRequest is closed`)
	}
	val := bool(C.StandardRequest_not_equal(C.StandardRequestHandle(h.chandle), C.StandardRequestHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[standardRequestHandle]() {
		return "", errors.New(`ToJSON The StandardRequest is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.StandardRequest_to_json_string(C.StandardRequestHandle(h.chandle))))
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
	h := standardRequestHandle(C.StandardRequest_from_json_string(C.StringHandle(capistr)))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
