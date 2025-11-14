package connection

import (
	"errors"
	"runtime"
	"sync"
)

type Connection struct {
	handle connectionHandle
	mu     sync.RWMutex
	closed bool
}

// Internal cleanup
func (c *Connection) closeHandle() error {
	c.mu.Lock()
	defer c.mu.Unlock()
	if !c.closed && c.handle != nilHandle() {
		destroy(c.handle)
		c.closed = true
		c.handle = nilHandle()
		return nil
	}
	return errors.New("unable to close the Connection")
}

func newConnection(createHandle func() connectionHandle) *Connection {
	conn := &Connection{handle: createHandle()}
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(conn, func(_ any) { conn.closeHandle() }, true)
	return conn
}

func NewBarrierGate(name string) *Connection {
	return newConnection(func() connectionHandle { return createBarrierGate(name) })
}

func NewPlungerGate(name string) *Connection {
	return newConnection(func() connectionHandle { return createPlungerGate(name) })
}

func NewReservoirGate(name string) *Connection {
	return newConnection(func() connectionHandle { return createReservoirGate(name) })
}

func NewScreeningGate(name string) *Connection {
	return newConnection(func() connectionHandle { return createScreeningGate(name) })
}

func NewOhmic(name string) *Connection {
	return newConnection(func() connectionHandle { return createOhmic(name) })
}

func ConnectionFromJSON(json string) *Connection {
	return newConnection(func() connectionHandle { return fromJSON(json) })
}

func (c *Connection) Close() {
	c.closeHandle()
}

func (c *Connection) Name() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return "", errors.New(`Connection:Name The connection is closed.`)
	}
	return name(c.handle), nil
}

func (c *Connection) Type() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return "", errors.New(`Connection:Type The connection is closed.`)
	}
	return connectionType(c.handle), nil
}

func (c *Connection) IsDotGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsDotGate The connection is closed.`)
	}
	return isDotGate(c.handle), nil
}

func (c *Connection) IsBarrierGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsBarrierGate The connection is closed.`)
	}
	return isBarrierGate(c.handle), nil
}

func (c *Connection) IsPlungerGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsPlungerGate The connection is closed.`)
	}
	return isPlungerGate(c.handle), nil
}

func (c *Connection) IsReservoirGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsReservoirGate The connection is closed.`)
	}
	return isReservoirGate(c.handle), nil
}

func (c *Connection) IsScreeningGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsReservoirGate The connection is closed.`)
	}
	return isScreeningGate(c.handle), nil
}

func (c *Connection) IsOhmic() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsReservoirGate The connection is closed.`)
	}
	return isOhmic(c.handle), nil
}

func (c *Connection) IsGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsReservoirGate The connection is closed.`)
	}
	return isGate(c.handle), nil
}

func (c *Connection) Equal(other *Connection) (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsReservoirGate The connection is closed.`)
	}
	return equal(c.handle, other.handle), nil
}

func (c *Connection) NotEqual(other *Connection) (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return false, errors.New(`Connection:IsReservoirGate The connection is closed.`)
	}
	return notEqual(c.handle, other.handle), nil
}

func (c *Connection) ToJSON() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.handle == nilHandle() {
		return "", errors.New(`Connection:IsReservoirGate The connection is closed.`)
	}
	return toJSON(c.handle), nil
}
