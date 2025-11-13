package devicestructures

import (
	"runtime"
	"sync"
)

type Connection struct {
	handle connectionHandle
	mu     sync.RWMutex
	closed bool
}

// Internal cleanup
func (c *Connection) closeHandle() {
	c.mu.Lock()
	defer c.mu.Unlock()
	if !c.closed && c.handle != nilHandle() {
		destroyConnection(c.handle)
		c.closed = true
		c.handle = nilHandle()
	}
}

func NewBarrierGate(name string) *Connection {
	handle := createBarrierGate(name)
	conn := &Connection{handle: handle}
	runtime.SetFinalizer(conn, func(c *Connection) { c.closeHandle() })
	return conn
}

func NewPlungerGate(name string) *Connection {
	handle := createPlungerGate(name)
	conn := &Connection{handle: handle}
	runtime.SetFinalizer(conn, func(c *Connection) { c.closeHandle() })
	return conn
}

func NewReservoirGate(name string) *Connection {
	handle := createReservoirGate(name)
	conn := &Connection{handle: handle}
	runtime.SetFinalizer(conn, func(c *Connection) { c.closeHandle() })
	return conn
}

func NewScreeningGate(name string) *Connection {
	handle := createScreeningGate(name)
	conn := &Connection{handle: handle}
	runtime.SetFinalizer(conn, func(c *Connection) { c.closeHandle() })
	return conn
}

func NewOhmic(name string) *Connection {
	handle := createOhmic(name)
	conn := &Connection{handle: handle}
	runtime.SetFinalizer(conn, func(c *Connection) { c.closeHandle() })
	return conn
}

func ConnectionFromJSON(json string) *Connection {
	handle := connectionFromJSON(json)
	conn := &Connection{handle: handle}
	runtime.SetFinalizer(conn, func(c *Connection) { c.closeHandle() })
	return conn
}

func (c *Connection) Close() error {
	c.closeHandle()
	runtime.SetFinalizer(c, nil)
	return nil
}

func (c *Connection) Name() string {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return ""
	}
	return connectionName(c.handle)
}

func (c *Connection) Type() string {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return ""
	}
	return connectionType(c.handle)
}

func (c *Connection) IsDotGate() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return isDotGate(c.handle)
}

func (c *Connection) IsBarrierGate() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return isBarrierGate(c.handle)
}

func (c *Connection) IsPlungerGate() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return isPlungerGate(c.handle)
}

func (c *Connection) IsReservoirGate() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return isReservoirGate(c.handle)
}

func (c *Connection) IsScreeningGate() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return isScreeningGate(c.handle)
}

func (c *Connection) IsOhmic() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return isOhmic(c.handle)
}

func (c *Connection) IsGate() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return isGate(c.handle)
}

func (c *Connection) Equal(other *Connection) bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return connectionEqual(c.handle, other.handle)
}

func (c *Connection) NotEqual(other *Connection) bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false
	}
	return connectionNotEqual(c.handle, other.handle)
}

func (c *Connection) ToJSON() string {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return ""
	}
	return connectionToJSON(c.handle)
}
