package deviceStructures

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

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type impedanceHandle C.ImpedanceHandle

type Impedance struct {
	handle impedanceHandle
	mu     sync.RWMutex
	closed bool
}

// Internal cleanup
func (i *Impedance) closeHandle() error {
	i.mu.Lock()
	defer i.mu.Unlock()
	if !i.closed && i.handle != utils.NilHandle[impedanceHandle]() {
		C.Impedance_destroy(C.ImpedanceHandle(i.handle))
		i.closed = true
		i.handle = utils.NilHandle[impedanceHandle]()
		return nil
	}
	return errors.New("unable to close the Impedance")
}

func newImpedance(i impedanceHandle) *Impedance {
	conn := &Impedance{handle: i}
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(conn, func(_ any) { conn.closeHandle() }, true)
	return conn
}

func NewImpedance(conn *Connection, resistance, capacitance float64) *Impedance {
	h := impedanceHandle(C.Impedance_create(
		C.ConnectionHandle(conn.handle),
		C.double(resistance),
		C.double(capacitance),
	))
	return newImpedance(h)
}

func (i *Impedance) Close() {
	i.closeHandle()
}

func (i *Impedance) Connection() (*Connection, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if !i.closed && i.handle != utils.NilHandle[impedanceHandle]() {
		return nil, errors.New(`Impedance:Connection The impedance is closed`)
	}
	h := connectionHandle(C.Impedance_connection(C.ImpedanceHandle(i.handle)))
	return newConnection(h), nil
}

func (i *Impedance) Resistance() (float64, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if !i.closed && i.handle != utils.NilHandle[impedanceHandle]() {
		return 0, errors.New(`Impedance:Resistance The impedance is closed`)
	}
	return float64(C.Impedance_resistance(C.ImpedanceHandle(i.handle))), nil
}

func (i *Impedance) Capacitance() (float64, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if !i.closed && i.handle != utils.NilHandle[impedanceHandle]() {
		return 0, errors.New(`Impedance:Capacitance The impedance is closed`)
	}
	return float64(C.Impedance_capacitance(C.ImpedanceHandle(i.handle))), nil
}

func (i *Impedance) Equal(other *Impedance) (bool, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if !i.closed && i.handle != utils.NilHandle[impedanceHandle]() {
		return false, errors.New(`Impedance:Equal The impedance is closed`)
	}
	return bool(C.Impedance_equal(C.ImpedanceHandle(i.handle), C.ImpedanceHandle(other.handle))), nil
}

func (i *Impedance) NotEqual(other *Impedance) (bool, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if !i.closed && i.handle != utils.NilHandle[impedanceHandle]() {
		return false, errors.New(`Impedance:Equal The impedance is closed`)
	}
	return bool(C.Impedance_not_equal(C.ImpedanceHandle(i.handle), C.ImpedanceHandle(other.handle))), nil
}

func (i *Impedance) ToJSON() (string, error) {
	i.mu.RLock()
	defer i.mu.RUnlock()
	if !i.closed && i.handle != utils.NilHandle[impedanceHandle]() {
		return "", errors.New("Impedance:ToJSON The impedance is closed")
	}
	sh := C.Impedance_to_json_string(C.ImpedanceHandle(i.handle))
	defer C.String_destroy(sh)
	return utils.CStringToGoString(unsafe.Pointer(sh.raw), int(sh.length)), nil
}

func ImpedanceFromJSON(json string) *Impedance {
	cjson := C.CString(json)
	defer C.free(unsafe.Pointer(cjson))
	realJSON := C.String_wrap(cjson)
	defer C.String_destroy(realJSON)
	h := impedanceHandle(C.Impedance_from_json_string(realJSON))
	return newImpedance(h)
}
