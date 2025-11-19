package vector

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectionpairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/point"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/voltage_states/DeviceVoltageStates_c_api.h>
#include <falcon_core/generic/ListConnection_c_api.h>
#include <falcon_core/generic/ListPairConnectionPairQuantityQuantity_c_api.h>
#include <falcon_core/generic/ListPairQuantityQuantity_c_api.h>
#include <falcon_core/generic/PairQuantityQuantity_c_api.h>
#include <falcon_core/math/Point_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/physics/units/SymbolUnit_c_api.h>
#include <falcon_core/math/Vector_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

type chandle C.VectorHandle

type Handle struct {
	chandle      chandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(h chandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(handle, func(h *Handle) { h.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(chandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Handle already closed")
	}
	C.Vector_destroy(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	h.closed = true
	h.chandle = nil
	return nil
}

// Constructors
func New(start, end *point.Handle) (*Handle, error) {
	startPtr, err := start.CAPIHandle()
	if err != nil {
		return nil, err
	}
	endPtr, err := end.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Vector_create(C.PointHandle(startPtr), C.PointHandle(endPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromEnd(end *point.Handle) (*Handle, error) {
	endPtr, err := end.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Vector_create_from_end(C.PointHandle(endPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromQuantities(start, end *mapconnectionquantity.Handle) (*Handle, error) {
	startPtr, err := start.CAPIHandle()
	if err != nil {
		return nil, err
	}
	endPtr, err := end.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Vector_create_from_quantities(C.MapConnectionQuantityHandle(startPtr), C.MapConnectionQuantityHandle(endPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromEndQuantities(end *mapconnectionquantity.Handle) (*Handle, error) {
	endPtr, err := end.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Vector_create_from_end_quantities(C.MapConnectionQuantityHandle(endPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromDoubles(start, end *mapconnectiondouble.Handle, unit *symbolunit.Handle) (*Handle, error) {
	startPtr, err := start.CAPIHandle()
	if err != nil {
		return nil, err
	}
	endPtr, err := end.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitPtr, err := unit.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Vector_create_from_doubles(C.MapConnectionDoubleHandle(startPtr), C.MapConnectionDoubleHandle(endPtr), C.SymbolUnitHandle(unitPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromEndDoubles(end *mapconnectiondouble.Handle, unit *symbolunit.Handle) (*Handle, error) {
	endPtr, err := end.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitPtr, err := unit.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Vector_create_from_end_doubles(C.MapConnectionDoubleHandle(endPtr), C.SymbolUnitHandle(unitPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromParent(items *mapconnectionquantity.Handle) (*Handle, error) {
	itemsPtr, err := items.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Vector_create_from_parent(C.MapConnectionQuantityHandle(itemsPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

// Methods
func (h *Handle) EndPoint() (*point.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("EndPoint: handle is closed")
	}
	cPoint := C.Vector_endPoint(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return point.FromCAPI(unsafe.Pointer(cPoint))
}

func (h *Handle) StartPoint() (*point.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("StartPoint: handle is closed")
	}
	cPoint := C.Vector_startPoint(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return point.FromCAPI(unsafe.Pointer(cPoint))
}

func (h *Handle) EndQuantities() (*mapconnectionquantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("EndQuantities: handle is closed")
	}
	cMap := C.Vector_end_quantities(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return mapconnectionquantity.FromCAPI(unsafe.Pointer(cMap))
}

func (h *Handle) StartQuantities() (*mapconnectionquantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("StartQuantities: handle is closed")
	}
	cMap := C.Vector_start_quantities(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return mapconnectionquantity.FromCAPI(unsafe.Pointer(cMap))
}

func (h *Handle) EndMap() (*mapconnectiondouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("EndMap: handle is closed")
	}
	cMap := C.Vector_end_map(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return mapconnectiondouble.FromCAPI(unsafe.Pointer(cMap))
}

func (h *Handle) StartMap() (*mapconnectiondouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("StartMap: handle is closed")
	}
	cMap := C.Vector_start_map(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return mapconnectiondouble.FromCAPI(unsafe.Pointer(cMap))
}

func (h *Handle) Connections() (*listconnection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Connections: handle is closed")
	}
	cList := C.Vector_connections(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listconnection.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Unit() (*symbolunit.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Unit: handle is closed")
	}
	cUnit := C.Vector_unit(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return symbolunit.FromCAPI(unsafe.Pointer(cUnit))
}

func (h *Handle) PrincipleConnection() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("PrincipleConnection: handle is closed")
	}
	cConn := C.Vector_principle_connection(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(cConn))
}

func (h *Handle) Magnitude() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Magnitude: handle is closed")
	}
	val := float64(C.Vector_magnitude(C.VectorHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) InsertOrAssign(key *connection.Handle, value *pairquantityquantity.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("InsertOrAssign: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return err
	}
	valPtr, err := value.CAPIHandle()
	if err != nil {
		return err
	}
	C.Vector_insert_or_assign(C.VectorHandle(h.chandle), C.ConnectionHandle(keyPtr), C.PairQuantityQuantityHandle(valPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Insert(key *connection.Handle, value *pairquantityquantity.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Insert: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return err
	}
	valPtr, err := value.CAPIHandle()
	if err != nil {
		return err
	}
	C.Vector_insert(C.VectorHandle(h.chandle), C.ConnectionHandle(keyPtr), C.PairQuantityQuantityHandle(valPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) At(key *connection.Handle) (*pairquantityquantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("At: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return nil, err
	}
	cPair := C.Vector_at(C.VectorHandle(h.chandle), C.ConnectionHandle(keyPtr))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return pairquantityquantity.FromCAPI(unsafe.Pointer(cPair))
}

func (h *Handle) Erase(key *connection.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Erase: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return err
	}
	C.Vector_erase(C.VectorHandle(h.chandle), C.ConnectionHandle(keyPtr))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Size: handle is closed")
	}
	val := int(C.Vector_size(C.VectorHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Empty: handle is closed")
	}
	val := bool(C.Vector_empty(C.VectorHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Clear: handle is closed")
	}
	C.Vector_clear(C.VectorHandle(h.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Contains: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Vector_contains(C.VectorHandle(h.chandle), C.ConnectionHandle(keyPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Keys() (*listconnection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Keys: handle is closed")
	}
	cList := C.Vector_keys(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listconnection.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Values() (*listpairquantityquantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Values: handle is closed")
	}
	cList := C.Vector_values(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listpairquantityquantity.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Items() (*listpairconnectionpairquantityquantity.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Items: handle is closed")
	}
	cList := C.Vector_items(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listpairconnectionpairquantityquantity.FromCAPI(unsafe.Pointer(cList))
}

// Arithmetic and transformation methods
func (h *Handle) Addition(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Addition: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("Addition: other handle is closed or nil")
	}
	res := chandle(C.Vector_addition(C.VectorHandle(h.chandle), C.VectorHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Subtraction(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Subtraction: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("Subtraction: other handle is closed or nil")
	}
	res := chandle(C.Vector_subtraction(C.VectorHandle(h.chandle), C.VectorHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DoubleMultiplication(scalar float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DoubleMultiplication: handle is closed")
	}
	res := chandle(C.Vector_double_multiplication(C.VectorHandle(h.chandle), C.double(scalar)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) IntMultiplication(scalar int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("IntMultiplication: handle is closed")
	}
	res := chandle(C.Vector_int_multiplication(C.VectorHandle(h.chandle), C.int(scalar)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DoubleDivision(scalar float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DoubleDivision: handle is closed")
	}
	res := chandle(C.Vector_double_division(C.VectorHandle(h.chandle), C.double(scalar)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) IntDivision(scalar int32) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("IntDivision: handle is closed")
	}
	res := chandle(C.Vector_int_division(C.VectorHandle(h.chandle), C.int(scalar)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Negation() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Negation: handle is closed")
	}
	res := chandle(C.Vector_negation(C.VectorHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) UpdateStartFromStates(state *devicevoltagestates.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("UpdateStartFromStates: handle is closed")
	}
	statePtr, err := state.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.Vector_update_start_from_states(C.VectorHandle(h.chandle), C.DeviceVoltageStatesHandle(statePtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TranslateDoubles(point *mapconnectiondouble.Handle, unit *symbolunit.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("TranslateDoubles: handle is closed")
	}
	pointPtr, err := point.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitPtr, err := unit.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.Vector_translate_doubles(C.VectorHandle(h.chandle), C.MapConnectionDoubleHandle(pointPtr), C.SymbolUnitHandle(unitPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TranslateQuantities(point *mapconnectionquantity.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("TranslateQuantities: handle is closed")
	}
	pointPtr, err := point.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.Vector_translate_quantities(C.VectorHandle(h.chandle), C.MapConnectionQuantityHandle(pointPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Translate(point *point.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Translate: handle is closed")
	}
	pointPtr, err := point.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.Vector_translate(C.VectorHandle(h.chandle), C.PointHandle(pointPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) TranslateToOrigin() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("TranslateToOrigin: handle is closed")
	}
	res := chandle(C.Vector_translate_to_origin(C.VectorHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DoubleExtend(extension float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DoubleExtend: handle is closed")
	}
	res := chandle(C.Vector_double_extend(C.VectorHandle(h.chandle), C.double(extension)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) IntExtend(extension int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("IntExtend: handle is closed")
	}
	res := chandle(C.Vector_int_extend(C.VectorHandle(h.chandle), C.int(extension)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) DoubleShrink(extension float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DoubleShrink: handle is closed")
	}
	res := chandle(C.Vector_double_shrink(C.VectorHandle(h.chandle), C.double(extension)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) IntShrink(extension int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("IntShrink: handle is closed")
	}
	res := chandle(C.Vector_int_shrink(C.VectorHandle(h.chandle), C.int(extension)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) UnitVector() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("UnitVector: handle is closed")
	}
	res := chandle(C.Vector_unit_vector(C.VectorHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Normalize() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Normalize: handle is closed")
	}
	res := chandle(C.Vector_normalize(C.VectorHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Project(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Project: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("Project: other handle is closed or nil")
	}
	res := chandle(C.Vector_project(C.VectorHandle(h.chandle), C.VectorHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) UpdateUnit(unit *symbolunit.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("UpdateUnit: handle is closed")
	}
	unitPtr, err := unit.CAPIHandle()
	if err != nil {
		return err
	}
	C.Vector_update_unit(C.VectorHandle(h.chandle), C.SymbolUnitHandle(unitPtr))
	return h.errorHandler.CheckCapiError()
}

// Equality
func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("Equal: other handle is closed or nil")
	}
	val := bool(C.Vector_equal(C.VectorHandle(h.chandle), C.VectorHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("NotEqual: other handle is closed or nil")
	}
	val := bool(C.Vector_not_equal(C.VectorHandle(h.chandle), C.VectorHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

// Serialization
func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.Vector_to_json_string(C.VectorHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return "", err
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func FromJSON(json string) (*Handle, error) {
	strHandle := str.New(json)
	defer strHandle.Close()
	strPtr, err := strHandle.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Vector_from_json_string(C.StringHandle(strPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
