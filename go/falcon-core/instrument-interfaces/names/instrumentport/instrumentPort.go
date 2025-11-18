package instrumentport

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/instrument_interfaces/names/InstrumentPort_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/physics/units/SymbolUnit_c_api.h>
#include <falcon_core/instrument_interfaces/names/InstrumentTypes_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

var stringFromCAPI = str.FromCAPI

type instrumentPortHandle C.InstrumentPortHandle

type Handle struct {
	chandle      instrumentPortHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return nil, errors.New("InstrumentPort is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(h instrumentPortHandle) *Handle {
	port := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(port, func(p *Handle) { p.Close() })
	return port
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is null")
	}
	return new(instrumentPortHandle(p)), nil
}

func NewPort(defaultName string, conn *connection.Handle, insttype string, unit *symbolunit.Handle, desc string) (*Handle, error) {
	name := str.New(defaultName)
	defer name.Close()
	namecapistr, err := name.CAPIHandle()
	if err != nil {
		return nil, err
	}
	itype := str.New(insttype)
	defer itype.Close()
	typecapistr, err := itype.CAPIHandle()
	if err != nil {
		return nil, err
	}
	descstr := str.New(desc)
	defer descstr.Close()
	desccapistr, err := descstr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	if conn == nil {
		return nil, errors.New(`new port cannot be created. invalid null connection`)
	}
	conncapi, err := conn.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New(`failed to access capi handle creating port for connection`), err)
	}
	if unit == nil {
		return nil, errors.New(`new port cannot be created. invalid null unit`)
	}
	unitcapi, err := unit.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New(`failed to access capi handle for unit creating port`), err)
	}
	h := instrumentPortHandle(C.InstrumentPort_create_port(C.StringHandle(namecapistr), C.ConnectionHandle(conncapi), C.StringHandle(typecapistr), C.SymbolUnitHandle(unitcapi), C.StringHandle(desccapistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewKnob(defaultName string, conn *connection.Handle, insttype string, unit *symbolunit.Handle, desc string) (*Handle, error) {
	name := str.New(defaultName)
	defer name.Close()
	namecapistr, err := name.CAPIHandle()
	if err != nil {
		return nil, err
	}
	itype := str.New(insttype)
	defer itype.Close()
	typecapistr, err := itype.CAPIHandle()
	if err != nil {
		return nil, err
	}
	descstr := str.New(desc)
	defer descstr.Close()
	desccapistr, err := descstr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	if conn == nil {
		return nil, errors.New(`new port cannot be created. invalid null connection`)
	}
	conncapi, err := conn.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New(`failed to access capi handle creating port for connection`), err)
	}
	if unit == nil {
		return nil, errors.New(`new port cannot be created. invalid null unit`)
	}
	unitcapi, err := unit.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New(`failed to access capi handle for unit creating port`), err)
	}
	h := instrumentPortHandle(C.InstrumentPort_create_knob(C.StringHandle(namecapistr), C.ConnectionHandle(conncapi), C.StringHandle(typecapistr), C.SymbolUnitHandle(unitcapi), C.StringHandle(desccapistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewMeter(defaultName string, conn *connection.Handle, insttype string, unit *symbolunit.Handle, desc string) (*Handle, error) {
	name := str.New(defaultName)
	defer name.Close()
	namecapistr, err := name.CAPIHandle()
	if err != nil {
		return nil, err
	}
	itype := str.New(insttype)
	defer itype.Close()
	typecapistr, err := itype.CAPIHandle()
	if err != nil {
		return nil, err
	}
	descstr := str.New(desc)
	defer descstr.Close()
	desccapistr, err := descstr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	if conn == nil {
		return nil, errors.New(`new port cannot be created. invalid null connection`)
	}
	conncapi, err := conn.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New(`failed to access capi handle creating port for connection`), err)
	}
	if unit == nil {
		return nil, errors.New(`new port cannot be created. invalid null unit`)
	}
	unitcapi, err := unit.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New(`failed to access capi handle for unit creating port`), err)
	}
	h := instrumentPortHandle(C.InstrumentPort_create_meter(C.StringHandle(namecapistr), C.ConnectionHandle(conncapi), C.StringHandle(typecapistr), C.SymbolUnitHandle(unitcapi), C.StringHandle(desccapistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewTimer() (*Handle, error) {
	h := instrumentPortHandle(C.InstrumentPort_create_timer())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewExecutionClock() (*Handle, error) {
	h := instrumentPortHandle(C.InstrumentPort_create_execution_clock())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func FromJSON(json string) (*Handle, error) {
	s := str.New(json)
	defer s.Close()
	capistr, err := s.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := instrumentPortHandle(C.InstrumentPort_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[instrumentPortHandle]() {
		C.InstrumentPort_destroy(C.InstrumentPortHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[instrumentPortHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

func (h *Handle) DefaultName() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return "", errors.New("DefaultName: InstrumentPort is closed")
	}
	s, err := stringFromCAPI(unsafe.Pointer(C.InstrumentPort_default_name(C.InstrumentPortHandle(h.chandle))))
	if err != nil {
		return "", err
	}
	defer s.Close()
	return s.ToGoString()
}

func (h *Handle) PsuedoName() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return nil, errors.New("PsuedoName: InstrumentPort is closed")
	}
	ptr := C.InstrumentPort_psuedo_name(C.InstrumentPortHandle(h.chandle))
	if ptr == nil {
		return nil, nil
	}
	return FromCAPI(unsafe.Pointer(ptr))
}

func (h *Handle) InstrumentType() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return "", errors.New("InstrumentType: InstrumentPort is closed")
	}
	s, err := stringFromCAPI(unsafe.Pointer(C.InstrumentPort_instrument_type(C.InstrumentPortHandle(h.chandle))))
	if err != nil {
		return "", err
	}
	defer s.Close()
	return s.ToGoString()
}

func (h *Handle) Units() (*symbolunit.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return nil, errors.New("Units: InstrumentPort is closed")
	}
	return symbolunit.FromCAPI(unsafe.Pointer(C.InstrumentPort_units(C.InstrumentPortHandle(h.chandle))))
}

func (h *Handle) Description() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return "", errors.New("Description: InstrumentPort is closed")
	}
	s, err := stringFromCAPI(unsafe.Pointer(C.InstrumentPort_description(C.InstrumentPortHandle(h.chandle))))
	if err != nil {
		return "", err
	}
	defer s.Close()
	return s.ToGoString()
}

func (h *Handle) InstrumentFacingName() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return "", errors.New("InstrumentFacingName: InstrumentPort is closed")
	}
	s, err := stringFromCAPI(unsafe.Pointer(C.InstrumentPort_instrument_facing_name(C.InstrumentPortHandle(h.chandle))))
	if err != nil {
		return "", err
	}
	defer s.Close()
	return s.ToGoString()
}

func (h *Handle) IsKnob() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return false, errors.New("IsKnob: InstrumentPort is closed")
	}
	val := bool(C.InstrumentPort_is_knob(C.InstrumentPortHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsMeter() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return false, errors.New("IsMeter: InstrumentPort is closed")
	}
	val := bool(C.InstrumentPort_is_meter(C.InstrumentPortHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsPort() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return false, errors.New("IsPort: InstrumentPort is closed")
	}
	val := bool(C.InstrumentPort_is_port(C.InstrumentPortHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return false, errors.New("Equal: InstrumentPort is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other InstrumentPort is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[instrumentPortHandle]() {
		return false, errors.New("Equal: other InstrumentPort is closed")
	}
	val := bool(C.InstrumentPort_equal(C.InstrumentPortHandle(h.chandle), C.InstrumentPortHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return false, errors.New("NotEqual: InstrumentPort is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other InstrumentPort is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[instrumentPortHandle]() {
		return false, errors.New("NotEqual: other InstrumentPort is closed")
	}
	val := bool(C.InstrumentPort_not_equal(C.InstrumentPortHandle(h.chandle), C.InstrumentPortHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[instrumentPortHandle]() {
		return "", errors.New("ToJSON: InstrumentPort is closed")
	}
	s, err := stringFromCAPI(unsafe.Pointer(C.InstrumentPort_to_json_string(C.InstrumentPortHandle(h.chandle))))
	if err != nil {
		return "", err
	}
	defer s.Close()
	return s.ToGoString()
}
