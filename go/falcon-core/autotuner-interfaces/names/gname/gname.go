package gname

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/names/Gname_c_api.h>
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

type gnameHandle C.GnameHandle

type Handle struct {
	chandle      gnameHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

// CAPIHandle provides access to the underlying CAPI handle for the Gname
func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gnameHandle]() {
		return nil, errors.New(`CAPIHandle The gname is closed`)
	}
	return unsafe.Pointer(h.chandle), nil
}

// new adds an auto cleanup whenever added to a constructor
func new(i gnameHandle) *Handle {
	gn := &Handle{chandle: i, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(gn, func(_ any) { gn.Close() }, true)
	return gn
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`GnameFromCAPI The pointer is null`)
	}
	return new(gnameHandle(p)), nil
}

// New creates a new Gname from a string
func New(name string) (*Handle, error) {
	strHandle := str.New(name)
	defer strHandle.Close()
	capistr, err := strHandle.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New construction failed from illegal string"), err)
	}
	h := gnameHandle(C.Gname_create(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

// NewFromNum creates a new Gname from an integer
func NewFromNum(num int) (*Handle, error) {
	h := gnameHandle(C.Gname_create_from_num(C.int(num)))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[gnameHandle]() {
		C.Gname_destroy(C.GnameHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[gnameHandle]()
		return nil
	}
	return errors.New("unable to close the Gname")
}

func (h *Handle) Gname() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gnameHandle]() {
		return "", errors.New(`Gname The gname is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Gname_gname(C.GnameHandle(h.chandle))))
	if err != nil {
		return "", errors.New(`Gname could not convert to a String. ` + err.Error())
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
	if h.closed || h.chandle == utils.NilHandle[gnameHandle]() {
		return false, errors.New(`Equal The gname is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other gname is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[gnameHandle]() {
		return false, errors.New(`Equal The other gname is closed`)
	}
	val := bool(C.Gname_equal(C.GnameHandle(h.chandle), C.GnameHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gnameHandle]() {
		return false, errors.New(`NotEqual The gname is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other gname is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[gnameHandle]() {
		return false, errors.New(`NotEqual The other gname is closed`)
	}
	val := bool(C.Gname_not_equal(C.GnameHandle(h.chandle), C.GnameHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gnameHandle]() {
		return "", errors.New(`ToJSON The gname is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Gname_to_json_string(C.GnameHandle(h.chandle))))
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
	h := gnameHandle(C.Gname_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
