package impedance

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/Impedance_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type impedanceHandle C.ImpedanceHandle

type Handle struct {
	chandle impedanceHandle
	mu      sync.RWMutex
	closed  bool
}

// CAPIHandle provides access to the underlying CAPI handle for the String
func (s *Handle) CAPIHandle() unsafe.Pointer {
	return unsafe.Pointer(s.chandle)
}

// new adds an auto cleanup whenever added to a constructor
func new(i impedanceHandle) *Handle {
	conn := &Handle{chandle: i}
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(conn, func(_ any) { conn.Close() }, true)
	return conn
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`ImpedanceFromCAPI The pointer is null`)
	}
	return new(impedanceHandle(p)), nil
}

func New(conn *connection.Handle, resistance, capacitance float64) *Handle {
	h := impedanceHandle(C.Impedance_create(
		C.ConnectionHandle(conn.CAPIHandle()),
		C.double(resistance),
		C.double(capacitance),
	))
	return new(h)
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[impedanceHandle]() {
		C.Impedance_destroy(C.ImpedanceHandle(h.chandle))
		h.closed = true
		h.chandle = utils.NilHandle[impedanceHandle]()
		return nil
	}
	return errors.New("unable to close the Impedance")
}

func (i *Handle) Connection() (*connection.Handle, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if i.closed || i.chandle == utils.NilHandle[impedanceHandle]() {
		return nil, errors.New(`Connection The impedance is closed`)
	}
	h := unsafe.Pointer(C.Impedance_connection(C.ImpedanceHandle(i.chandle)))
	return connection.FromCAPI(h)
}

func (i *Handle) Resistance() (float64, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if i.closed || i.chandle == utils.NilHandle[impedanceHandle]() {
		return 0, errors.New(`Resistance The impedance is closed`)
	}
	return float64(C.Impedance_resistance(C.ImpedanceHandle(i.chandle))), nil
}

func (i *Handle) Capacitance() (float64, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if i.closed || i.chandle == utils.NilHandle[impedanceHandle]() {
		return 0, errors.New(`Capacitance The impedance is closed`)
	}
	return float64(C.Impedance_capacitance(C.ImpedanceHandle(i.chandle))), nil
}

func (i *Handle) Equal(other *Handle) (bool, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if i.closed || i.chandle == utils.NilHandle[impedanceHandle]() {
		return false, errors.New(`Equal The impedance is closed`)
	}
	return bool(C.Impedance_equal(C.ImpedanceHandle(i.chandle), C.ImpedanceHandle(other.chandle))), nil
}

func (i *Handle) NotEqual(other *Handle) (bool, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if i.closed || i.chandle == utils.NilHandle[impedanceHandle]() {
		return false, errors.New(`Equal The impedance is closed`)
	}
	return bool(C.Impedance_not_equal(C.ImpedanceHandle(i.chandle), C.ImpedanceHandle(other.chandle))), nil
}

func (i *Handle) ToJSON() (string, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if i.closed || i.chandle == utils.NilHandle[impedanceHandle]() {
		return "", errors.New(`ToJSON The connection is closed`)
	}
	str, err := str.FromCAPI(unsafe.Pointer(C.Impedance_to_json_string(C.ImpedanceHandle(i.chandle))))
	if err != nil {
		return "", errors.New(`ToJSON could not convert to a String. ` + err.Error())
	}
	defer str.Close()
	return str.ToGoString()
}

func ImpedanceFromJSON(json string) *Handle {
	realJSON := str.New(json)
	defer realJSON.Close()
	h := impedanceHandle(C.Impedance_from_json_string(C.StringHandle(realJSON.CAPIHandle())))
	return new(h)
}
