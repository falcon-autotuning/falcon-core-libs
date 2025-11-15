package deviceStructures

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/Connection_c_api.h>
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

type connectionHandle C.ConnectionHandle

type Connection struct {
	handle connectionHandle
	mu     sync.RWMutex
	closed bool
}

// Internal cleanup
func (c *Connection) closeHandle() error {
	c.mu.Lock()
	defer c.mu.Unlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		C.Connection_destroy(C.ConnectionHandle(c.handle))
		c.closed = true
		c.handle = utils.NilHandle[connectionHandle]()
		return nil
	}
	return errors.New("unable to close the Connection")
}

func newConnection(h connectionHandle) *Connection {
	conn := &Connection{handle: h}
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(conn, func(_ any) { conn.closeHandle() }, true)
	return conn
}

func NewBarrierGate(name string) *Connection {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	h := connectionHandle(C.Connection_create_barrier_gate(realName))
	return newConnection(h)
}

func NewPlungerGate(name string) *Connection {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	h := connectionHandle(C.Connection_create_plunger_gate(realName))
	return newConnection(h)
}

func NewReservoirGate(name string) *Connection {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	h := connectionHandle(C.Connection_create_reservoir_gate(realName))
	return newConnection(h)
}

func NewScreeningGate(name string) *Connection {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	h := connectionHandle(C.Connection_create_screening_gate(realName))
	return newConnection(h)
}

func NewOhmic(name string) *Connection {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	h := connectionHandle(C.Connection_create_ohmic(realName))
	return newConnection(h)
}

func ConnectionFromJSON(json string) *Connection {
	cjson := C.CString(json)
	defer C.free(unsafe.Pointer(cjson))
	realJSON := C.String_wrap(cjson)
	defer C.String_destroy(realJSON)
	h := connectionHandle(C.Connection_from_json_string(realJSON))
	return newConnection(h)
}

func (c *Connection) Close() {
	c.closeHandle()
}

func (c *Connection) Name() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return "", errors.New(`Connection:Name The connection is closed`)
	}
	sh := C.Connection_name(C.ConnectionHandle(c.handle))
	defer C.String_destroy(sh)
	return utils.CStringToGoString(sh.raw, sh.length), nil
}

func (c *Connection) Type() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return "", errors.New(`Connection:Type The connection is closed`)
	}
	sh := C.Connection_type(C.ConnectionHandle(c.handle))
	defer C.String_destroy(sh)
	return utils.CStringToGoString(sh.raw, sh.length), nil
}

func (c *Connection) IsDotGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:IsDotGate The connection is closed`)
	}
	return bool(C.Connection_is_dot_gate(C.ConnectionHandle(c.handle))), nil
}

func (c *Connection) IsBarrierGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:IsBarrierGate The connection is closed`)
	}
	return bool(C.Connection_is_barrier_gate(C.ConnectionHandle(c.handle))), nil
}

func (c *Connection) IsPlungerGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:IsPlungerGate The connection is closed`)
	}
	return bool(C.Connection_is_plunger_gate(C.ConnectionHandle(c.handle))), nil
}

func (c *Connection) IsReservoirGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:IsReservoirGate The connection is closed`)
	}
	return bool(C.Connection_is_reservoir_gate(C.ConnectionHandle(c.handle))), nil
}

func (c *Connection) IsScreeningGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:IsScreeningGate The connection is closed`)
	}
	return bool(C.Connection_is_screening_gate(C.ConnectionHandle(c.handle))), nil
}

func (c *Connection) IsOhmic() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:IsOhmic The connection is closed`)
	}
	return bool(C.Connection_is_ohmic(C.ConnectionHandle(c.handle))), nil
}

func (c *Connection) IsGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:IsGate The connection is closed`)
	}
	return bool(C.Connection_is_gate(C.ConnectionHandle(c.handle))), nil
}

func (c *Connection) Equal(other *Connection) (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:Equal The connection is closed`)
	}
	return bool(C.Connection_equal(C.ConnectionHandle(c.handle), C.ConnectionHandle(other.handle))), nil
}

func (c *Connection) NotEqual(other *Connection) (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Connection:NotEqual The connection is closed`)
	}
	return bool(C.Connection_not_equal(C.ConnectionHandle(c.handle), C.ConnectionHandle(other.handle))), nil
}

func (c *Connection) ToJSON() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if !c.closed && c.handle != utils.NilHandle[connectionHandle]() {
		return "", errors.New(`Connection:ToJSON The connection is closed`)
	}
	sh := C.Connection_to_json_string(C.ConnectionHandle(c.handle))
	defer C.String_destroy(sh)
	return utils.CStringToGoString(sh.raw, sh.length), nil
}
