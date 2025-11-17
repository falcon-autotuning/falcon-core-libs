package channel

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/names/Channel_c_api.h>
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

type channelHandle C.ChannelHandle

type Handle struct {
	chandle      channelHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorHandling.Handle
}

// CAPIHandle provides access to the underlying CAPI handle for the Channel
func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelHandle]() {
		return nil, errors.New(`CAPIHandle The channel is closed`)
	}
	return unsafe.Pointer(h.chandle), nil
}

// new adds an auto cleanup whenever added to a constructor
func new(i channelHandle) *Handle {
	ch := &Handle{chandle: i, errorHandler: errorHandling.ErrorHandler}
	runtime.AddCleanup(ch, func(_ any) { ch.Close() }, true)
	return ch
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`ChannelFromCAPI The pointer is null`)
	}
	return new(channelHandle(p)), nil
}

// New creates a new Channel from a name
func New(name string) (*Handle, error) {
	strHandle := str.New(name)
	defer strHandle.Close()
	capistr, err := strHandle.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New construction failed from illegal string"), err)
	}
	h := channelHandle(C.Channel_create(C.StringHandle(capistr)))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[channelHandle]() {
		C.Channel_destroy(C.ChannelHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[channelHandle]()
		return nil
	}
	return errors.New("unable to close the Channel")
}

func (h *Handle) Name() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelHandle]() {
		return "", errors.New(`Name The channel is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Channel_name(C.ChannelHandle(h.chandle))))
	if err != nil {
		return "", errors.New(`Name could not convert to a String. ` + err.Error())
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
	if h.closed || h.chandle == utils.NilHandle[channelHandle]() {
		return false, errors.New(`Equal The channel is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other channel is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[channelHandle]() {
		return false, errors.New(`Equal The other channel is closed`)
	}
	val := bool(C.Channel_equal(C.ChannelHandle(h.chandle), C.ChannelHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelHandle]() {
		return false, errors.New(`NotEqual The channel is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other channel is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[channelHandle]() {
		return false, errors.New(`NotEqual The other channel is closed`)
	}
	val := bool(C.Channel_not_equal(C.ChannelHandle(h.chandle), C.ChannelHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelHandle]() {
		return "", errors.New(`ToJSON The channel is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Channel_to_json_string(C.ChannelHandle(h.chandle))))
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
	h := channelHandle(C.Channel_from_json_string(C.StringHandle(capistr)))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
