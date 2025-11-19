package point

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/Point_c_api.h>
#include <falcon_core/generic/ListConnection_c_api.h>
#include <falcon_core/generic/MapConnectionDouble_c_api.h>
#include <falcon_core/generic/MapConnectionQuantity_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/Quantity_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/physics/units/SymbolUnit_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type pointHandle C.PointHandle

type Handle struct {
	chandle      pointHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle pointHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(obj, func(obj *Handle) { obj.Close() })
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI The pointer is null")
	}
	return new(pointHandle(p)), nil
}

func NewEmpty() (*Handle, error) {
	h := pointHandle(C.Point_create_empty())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func Create(items *mapconnectiondouble.Handle, unit *symbolunit.Handle) (*Handle, error) {
	if items == nil || unit == nil {
		return nil, errors.New("Create failed: items or unit is nil")
	}
	capiItems, err := items.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("Create failed: could not get CAPI handle for items"), err)
	}
	capiUnit, err := unit.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("Create failed: could not get CAPI handle for unit"), err)
	}
	h := pointHandle(C.Point_create(C.MapConnectionDoubleHandle(capiItems), C.SymbolUnitHandle(capiUnit)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func CreateFromParent(items *mapconnectionquantity.Handle) (*Handle, error) {
	if items == nil {
		return nil, errors.New("CreateFromParent failed: items is nil")
	}
	capiItems, err := items.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("CreateFromParent failed: could not get CAPI handle for items"), err)
	}
	h := pointHandle(C.Point_create_from_parent(C.MapConnectionQuantityHandle(capiItems)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[pointHandle]() {
		C.Point_destroy(C.PointHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[pointHandle]()
		return nil
	}
	return errors.New("unable to close the Point")
}

func (h *Handle) Unit() (*symbolunit.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Unit The object is closed")
	}
	cHandle := unsafe.Pointer(C.Point_unit(C.PointHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return symbolunit.FromCAPI(cHandle)
}

func (h *Handle) InsertOrAssign(key *connection.Handle, value *quantity.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return errors.New("InsertOrAssign The object is closed")
	}
	if key == nil || value == nil {
		return errors.New("InsertOrAssign key or value is nil")
	}
	capiKey, err := key.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("InsertOrAssign failed to get CAPI handle for key"), err)
	}
	capiValue, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("InsertOrAssign failed to get CAPI handle for value"), err)
	}
	C.Point_insert_or_assign(C.PointHandle(h.chandle), C.ConnectionHandle(capiKey), C.QuantityHandle(capiValue))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Insert(key *connection.Handle, value *quantity.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return errors.New("Insert The object is closed")
	}
	if key == nil || value == nil {
		return errors.New("Insert key or value is nil")
	}
	capiKey, err := key.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("Insert failed to get CAPI handle for key"), err)
	}
	capiValue, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("Insert failed to get CAPI handle for value"), err)
	}
	C.Point_insert(C.PointHandle(h.chandle), C.ConnectionHandle(capiKey), C.QuantityHandle(capiValue))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) At(key *connection.Handle) (*quantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("At The object is closed")
	}
	if key == nil {
		return nil, errors.New("At key is nil")
	}
	capiKey, err := key.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("At failed to get CAPI handle for key"), err)
	}
	cHandle := unsafe.Pointer(C.Point_at(C.PointHandle(h.chandle), C.ConnectionHandle(capiKey)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return quantity.FromCAPI(cHandle)
}

func (h *Handle) Erase(key *connection.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return errors.New("Erase The object is closed")
	}
	if key == nil {
		return errors.New("Erase key is nil")
	}
	capiKey, err := key.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("Erase failed to get CAPI handle for key"), err)
	}
	C.Point_erase(C.PointHandle(h.chandle), C.ConnectionHandle(capiKey))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return 0, errors.New("Size The object is closed")
	}
	val := int(C.Point_size(C.PointHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return false, errors.New("Empty The object is closed")
	}
	val := bool(C.Point_empty(C.PointHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return errors.New("Clear The object is closed")
	}
	C.Point_clear(C.PointHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return false, errors.New("Contains The object is closed")
	}
	if key == nil {
		return false, errors.New("Contains key is nil")
	}
	capiKey, err := key.CAPIHandle()
	if err != nil {
		return false, errors.Join(errors.New("Contains failed to get CAPI handle for key"), err)
	}
	val := bool(C.Point_contains(C.PointHandle(h.chandle), C.ConnectionHandle(capiKey)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Keys() ([]*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Keys The object is closed")
	}
	cList := C.Point_keys(C.PointHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	listHandle, err := listconnection.FromCAPI(unsafe.Pointer(cList))
	if err != nil {
		return nil, err
	}
	defer listHandle.Close()
	return listHandle.Items()
}

func (h *Handle) Values() (*listquantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Values The object is closed")
	}
	cList := C.Point_values(C.PointHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return listquantity.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Items() (*listpairconnectionquantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Items The object is closed")
	}
	cList := C.Point_items(C.PointHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return listpairconnectionquantity.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Coordinates() (*mapconnectionquantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Coordinates The object is closed")
	}
	cHandle := unsafe.Pointer(C.Point_coordinates(C.PointHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return mapconnectionquantity.FromCAPI(cHandle)
}

func (h *Handle) Connections() ([]*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Connections The object is closed")
	}
	cList := C.Point_connections(C.PointHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	listHandle, err := listconnection.FromCAPI(unsafe.Pointer(cList))
	if err != nil {
		return nil, err
	}
	defer listHandle.Close()
	return listHandle.Items()
}

func (h *Handle) Addition(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Addition The object is closed")
	}
	if other == nil {
		return nil, errors.New("Addition The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Addition The other object is closed")
	}
	res := pointHandle(C.Point_addition(C.PointHandle(h.chandle), C.PointHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Subtraction(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Subtraction The object is closed")
	}
	if other == nil {
		return nil, errors.New("Subtraction The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Subtraction The other object is closed")
	}
	res := pointHandle(C.Point_subtraction(C.PointHandle(h.chandle), C.PointHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Multiplication(scalar float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Multiplication The object is closed")
	}
	res := pointHandle(C.Point_multiplication(C.PointHandle(h.chandle), C.double(scalar)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Division(scalar float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Division The object is closed")
	}
	res := pointHandle(C.Point_division(C.PointHandle(h.chandle), C.double(scalar)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Negation() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return nil, errors.New("Negation The object is closed")
	}
	res := pointHandle(C.Point_negation(C.PointHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) SetUnit(unit *symbolunit.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return errors.New("SetUnit The object is closed")
	}
	if unit == nil {
		return errors.New("SetUnit unit is nil")
	}
	capiUnit, err := unit.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("SetUnit failed to get CAPI handle for unit"), err)
	}
	C.Point_set_unit(C.PointHandle(h.chandle), C.SymbolUnitHandle(capiUnit))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return false, errors.New("Equal The object is closed")
	}
	if other == nil {
		return false, errors.New("Equal The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[pointHandle]() {
		return false, errors.New("Equal The other object is closed")
	}
	val := bool(C.Point_equal(C.PointHandle(h.chandle), C.PointHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return false, errors.New("NotEqual The object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[pointHandle]() {
		return false, errors.New("NotEqual The other object is closed")
	}
	val := bool(C.Point_not_equal(C.PointHandle(h.chandle), C.PointHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[pointHandle]() {
		return "", errors.New("ToJSON The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Point_to_json_string(C.PointHandle(h.chandle))))
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
	h := pointHandle(C.Point_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
