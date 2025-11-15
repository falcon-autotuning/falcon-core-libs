package connections

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/Connections_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/generic/ListConnectio_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"
)

type connectionsHandle C.ConnectionsHandle

type Connections struct {
	handle connectionsHandle
	mu     sync.RWMutex
	closed bool
}

// Helper to convert C string to Go string
func cStringToGoString(raw *C.char, length C.ulong) string {
	return string(C.GoBytes(unsafe.Pointer(raw), C.int(length)))
}

func nilHandle() connectionsHandle { return nil }

// Internal cleanup
func (c *Connections) closeHandle() error {
	c.mu.Lock()
	defer c.mu.Unlock()
	if !c.closed && c.handle != nilHandle() {
		C.Connections_destroy(C.ConnectionsHandle(c.handle))
		c.closed = true
		c.handle = nilHandle()
		return nil
	}
	return errors.New("unable to close the Connections")
}

func newConnections(h connectionsHandle) *Connections {
	conn := &Connections{handle: h}
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(conn, func(_ any) { conn.closeHandle() }, true)
	return conn
}

func CreateEmpty() *Connections {
	h := connectionsHandle(C.Connections_create_empty())
	return newConnections(h)
}

// TODO:: Finish filling class out
