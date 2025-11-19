package devicevoltagestates

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListDeviceVoltageState_c_api.h>
#include <falcon_core/communications/voltage_states/DeviceVoltageState_c_api.h>
#include <falcon_core/communications/voltage_states/DeviceVoltageStates_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/Point_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdevicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/point"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type deviceVoltageStatesHandle C.DeviceVoltageStatesHandle

type Handle struct {
	chandle      deviceVoltageStatesHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle deviceVoltageStatesHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(obj, func(obj *Handle) { obj.Close() })
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI The pointer is null")
	}
	return new(deviceVoltageStatesHandle(p)), nil
}

func NewEmpty() (*Handle, error) {
	h := deviceVoltageStatesHandle(C.DeviceVoltageStates_create_empty())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func CreateFromList(items *listdevicevoltagestate.Handle) (*Handle, error) {
	if items == nil {
		return nil, errors.New("CreateFromList failed: items is nil")
	}
	capi, err := items.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("CreateFromList failed: could not get CAPI handle for items"), err)
	}
	h := deviceVoltageStatesHandle(C.DeviceVoltageStates_create(C.ListDeviceVoltageStateHandle(capi)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func New(items []*devicevoltagestate.Handle) (*Handle, error) {
	list, err := listdevicevoltagestate.New(items)
	if err != nil {
		return nil, errors.Join(errors.New(`construction of list of devicevoltagestate failed`), err)
	}
	return CreateFromList(list)
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[deviceVoltageStatesHandle]() {
		C.DeviceVoltageStates_destroy(C.DeviceVoltageStatesHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[deviceVoltageStatesHandle]()
		return nil
	}
	return errors.New("unable to close the DeviceVoltageStates")
}

func (h *Handle) States() ([]*devicevoltagestate.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("States The object is closed")
	}
	cList := C.DeviceVoltageStates_states(C.DeviceVoltageStatesHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	listHandle, err := listdevicevoltagestate.FromCAPI(unsafe.Pointer(cList))
	if err != nil {
		return nil, err
	}
	defer listHandle.Close()
	return listHandle.Items()
}

func (h *Handle) AddState(state *devicevoltagestate.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return errors.New("AddState The object is closed")
	}
	if state == nil {
		return errors.New("AddState state is nil")
	}
	capi, err := state.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("AddState failed to get CAPI handle for state"), err)
	}
	C.DeviceVoltageStates_add_state(C.DeviceVoltageStatesHandle(h.chandle), C.DeviceVoltageStateHandle(capi))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) FindState(conn *connection.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("FindState The object is closed")
	}
	if conn == nil {
		return nil, errors.New("FindState connection is nil")
	}
	capi, err := conn.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("FindState failed to get CAPI handle for connection"), err)
	}
	res := deviceVoltageStatesHandle(C.DeviceVoltageStates_find_state(C.DeviceVoltageStatesHandle(h.chandle), C.ConnectionHandle(capi)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) ToPoint() (*point.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("ToPoint The object is closed")
	}
	cHandle := unsafe.Pointer(C.DeviceVoltageStates_to_point(C.DeviceVoltageStatesHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return point.FromCAPI(cHandle)
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("Intersection The object is closed")
	}
	if other == nil {
		return nil, errors.New("Intersection The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("Intersection The other object is closed")
	}
	res := deviceVoltageStatesHandle(C.DeviceVoltageStates_intersection(C.DeviceVoltageStatesHandle(h.chandle), C.DeviceVoltageStatesHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PushBack(value *devicevoltagestate.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return errors.New("PushBack The object is closed")
	}
	if value == nil {
		return errors.New("PushBack value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("PushBack failed to get CAPI handle for value"), err)
	}
	C.DeviceVoltageStates_push_back(C.DeviceVoltageStatesHandle(h.chandle), C.DeviceVoltageStateHandle(capi))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return 0, errors.New("Size The object is closed")
	}
	val := int(C.DeviceVoltageStates_size(C.DeviceVoltageStatesHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return false, errors.New("Empty The object is closed")
	}
	val := bool(C.DeviceVoltageStates_empty(C.DeviceVoltageStatesHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return errors.New("EraseAt The object is closed")
	}
	C.DeviceVoltageStates_erase_at(C.DeviceVoltageStatesHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return errors.New("Clear The object is closed")
	}
	C.DeviceVoltageStates_clear(C.DeviceVoltageStatesHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) ConstAt(idx int) (*devicevoltagestate.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("ConstAt The object is closed")
	}
	cHandle := unsafe.Pointer(C.DeviceVoltageStates_const_at(C.DeviceVoltageStatesHandle(h.chandle), C.size_t(idx)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return devicevoltagestate.FromCAPI(cHandle)
}

func (h *Handle) At(idx int) (*devicevoltagestate.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("At The object is closed")
	}
	cHandle := unsafe.Pointer(C.DeviceVoltageStates_at(C.DeviceVoltageStatesHandle(h.chandle), C.size_t(idx)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return devicevoltagestate.FromCAPI(cHandle)
}

func (h *Handle) Items() ([]*devicevoltagestate.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return nil, errors.New("Items The object is closed")
	}
	cList := C.DeviceVoltageStates_items(C.DeviceVoltageStatesHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	listHandle, err := listdevicevoltagestate.FromCAPI(unsafe.Pointer(cList))
	if err != nil {
		return nil, err
	}
	defer listHandle.Close()
	return listHandle.Items()
}

func (h *Handle) Contains(value *devicevoltagestate.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return false, errors.New("Contains The object is closed")
	}
	if value == nil {
		return false, errors.New("Contains value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return false, errors.Join(errors.New("Contains failed to get CAPI handle for value"), err)
	}
	val := bool(C.DeviceVoltageStates_contains(C.DeviceVoltageStatesHandle(h.chandle), C.DeviceVoltageStateHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Index(value *devicevoltagestate.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return 0, errors.New("Index The object is closed")
	}
	if value == nil {
		return 0, errors.New("Index value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return 0, errors.Join(errors.New("Index failed to get CAPI handle for value"), err)
	}
	val := int(C.DeviceVoltageStates_index(C.DeviceVoltageStatesHandle(h.chandle), C.DeviceVoltageStateHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return false, errors.New("Equal The object is closed")
	}
	if other == nil {
		return false, errors.New("Equal The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return false, errors.New("Equal The other object is closed")
	}
	val := bool(C.DeviceVoltageStates_equal(C.DeviceVoltageStatesHandle(h.chandle), C.DeviceVoltageStatesHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return false, errors.New("NotEqual The object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return false, errors.New("NotEqual The other object is closed")
	}
	val := bool(C.DeviceVoltageStates_not_equal(C.DeviceVoltageStatesHandle(h.chandle), C.DeviceVoltageStatesHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[deviceVoltageStatesHandle]() {
		return "", errors.New("ToJSON The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.DeviceVoltageStates_to_json_string(C.DeviceVoltageStatesHandle(h.chandle))))
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
	h := deviceVoltageStatesHandle(C.DeviceVoltageStates_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
