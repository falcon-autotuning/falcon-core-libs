package channels

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/names/Channel_c_api.h>
#include <falcon_core/generic/ListChannel_c_api.h>
#include <falcon_core/generic/ListString_c_api.h>
#include <falcon_core/autotuner_interfaces/names/Channels_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listchannel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type channelsHandle C.ChannelsHandle

type Handle struct {
	chandle      channelsHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle channelsHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(obj, func(_ any) { obj.Close() }, true)
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI The pointer is null")
	}
	return new(channelsHandle(p)), nil
}

func NewEmpty() (*Handle, error) {
	h := channelsHandle(C.Channels_create_empty())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func CreateFromList(items *listchannel.Handle) (*Handle, error) {
	if items == nil {
		return nil, errors.New("New failed: items is nil")
	}
	capi, err := items.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for items"), err)
	}
	h := channelsHandle(C.Channels_create(C.ListChannelHandle(capi)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func New(items []*channel.Handle) (*Handle, error) {
	list, err := listchannel.New(items)
	if err != nil {
		return nil, errors.Join(errors.New(`construction of list of channel failed`), err)
	}
	return CreateFromList(list)
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[channelsHandle]() {
		C.Channels_destroy(C.ChannelsHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[channelsHandle]()
		return nil
	}
	return errors.New("unable to close the Channels")
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return nil, errors.New("Intersection The object is closed")
	}
	if other == nil {
		return nil, errors.New("Intersection The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[channelsHandle]() {
		return nil, errors.New("Intersection The other object is closed")
	}
	res := channelsHandle(C.Channels_intersection(C.ChannelsHandle(h.chandle), C.ChannelsHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PushBack(value *channel.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return errors.New("PushBack The object is closed")
	}
	if value == nil {
		return errors.New("PushBack value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("PushBack failed to get CAPI handle for value"), err)
	}
	C.Channels_push_back(C.ChannelsHandle(h.chandle), C.ChannelHandle(capi))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return 0, errors.New("Size The object is closed")
	}
	val := int(C.Channels_size(C.ChannelsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return false, errors.New("Empty The object is closed")
	}
	val := bool(C.Channels_empty(C.ChannelsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return errors.New("EraseAt The object is closed")
	}
	C.Channels_erase_at(C.ChannelsHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return errors.New("Clear The object is closed")
	}
	C.Channels_clear(C.ChannelsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) At(idx int) (*channel.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return nil, errors.New("At The object is closed")
	}
	cHandle := unsafe.Pointer(C.Channels_at(C.ChannelsHandle(h.chandle), C.size_t(idx)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return channel.FromCAPI(cHandle)
}

func (h *Handle) Items() ([]string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return nil, errors.New("Items The object is closed")
	}
	cList := C.Channels_items(C.ChannelsHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	listHandle, err := liststring.FromCAPI(unsafe.Pointer(cList))
	if err != nil {
		return nil, err
	}
	defer listHandle.Close()
	return listHandle.Items()
}

func (h *Handle) Contains(value *channel.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return false, errors.New("Contains The object is closed")
	}
	if value == nil {
		return false, errors.New("Contains value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return false, errors.Join(errors.New("Contains failed to get CAPI handle for value"), err)
	}
	val := bool(C.Channels_contains(C.ChannelsHandle(h.chandle), C.ChannelHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Index(value *channel.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return 0, errors.New("Index The object is closed")
	}
	if value == nil {
		return 0, errors.New("Index value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return 0, errors.Join(errors.New("Index failed to get CAPI handle for value"), err)
	}
	val := int(C.Channels_index(C.ChannelsHandle(h.chandle), C.ChannelHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return false, errors.New("Equal The object is closed")
	}
	if other == nil {
		return false, errors.New("Equal The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[channelsHandle]() {
		return false, errors.New("Equal The other object is closed")
	}
	val := bool(C.Channels_equal(C.ChannelsHandle(h.chandle), C.ChannelsHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return false, errors.New("NotEqual The object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[channelsHandle]() {
		return false, errors.New("NotEqual The other object is closed")
	}
	val := bool(C.Channels_not_equal(C.ChannelsHandle(h.chandle), C.ChannelsHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[channelsHandle]() {
		return "", errors.New("ToJSON The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Channels_to_json_string(C.ChannelsHandle(h.chandle))))
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

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("failed to access capi for json"), err)
	}
	h := channelsHandle(C.Channels_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
