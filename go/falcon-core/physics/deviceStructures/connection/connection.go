package connection

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

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorHandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

var stringFromCAPI = str.FromCAPI

type connectionHandle C.ConnectionHandle

type Handle struct {
	chandle      connectionHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorHandling.Handle
}

// CAPIHandle provides access to the underlying CAPI handle for the String
func (s *Handle) CAPIHandle() unsafe.Pointer {
	return unsafe.Pointer(s.chandle)
}

// new adds an auto cleanup whenever added to a constructor
func new(h connectionHandle) *Handle {
	conn := &Handle{chandle: h, errorHandler: errorHandling.ErrorHandler}
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(conn, func(_ any) { conn.Close() }, true)
	return conn
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`FromCAPI The pointer is null`)
	}
	return new(connectionHandle(p)), nil
}

func NewBarrierGate(name string) (*Handle, error) {
	str := str.New(name)
	defer str.Close()
	h := connectionHandle(C.Connection_create_barrier_gate(C.StringHandle(str.CAPIHandle())))
	err := errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewPlungerGate(name string) (*Handle, error) {
	str := str.New(name)
	defer str.Close()
	h := connectionHandle(C.Connection_create_plunger_gate(C.StringHandle(str.CAPIHandle())))
	err := errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewReservoirGate(name string) (*Handle, error) {
	str := str.New(name)
	defer str.Close()
	h := connectionHandle(C.Connection_create_reservoir_gate(C.StringHandle(str.CAPIHandle())))
	err := errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewScreeningGate(name string) (*Handle, error) {
	str := str.New(name)
	defer str.Close()
	h := connectionHandle(C.Connection_create_screening_gate(C.StringHandle(str.CAPIHandle())))
	err := errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewOhmic(name string) (*Handle, error) {
	str := str.New(name)
	defer str.Close()
	h := connectionHandle(C.Connection_create_ohmic(C.StringHandle(str.CAPIHandle())))
	err := errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	h := connectionHandle(C.Connection_from_json_string(C.StringHandle(realJSON.CAPIHandle())))
	err := errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (c *Handle) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()
	if !c.closed && c.chandle != utils.NilHandle[connectionHandle]() {
		C.Connection_destroy(C.ConnectionHandle(c.chandle))
		err := c.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		c.closed = true
		c.chandle = utils.NilHandle[connectionHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

func (c *Handle) Name() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return "", errors.New(`Name The connection is closed`)
	}
	str, err := stringFromCAPI(unsafe.Pointer(C.Connection_name(C.ConnectionHandle(c.chandle))))
	if err != nil {
		return "", errors.New(`Name:` + err.Error())
	}
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer str.Close()
	return str.ToGoString()
}

func (c *Handle) Type() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return "", errors.New(`Type The connection is closed`)
	}
	str, err := stringFromCAPI(unsafe.Pointer(C.Connection_type(C.ConnectionHandle(c.chandle))))
	if err != nil {
		return "", errors.New(`Type:` + err.Error())
	}
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer str.Close()
	return str.ToGoString()
}

func (c *Handle) IsDotGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`IsDotGate The connection is closed`)
	}
	val := bool(C.Connection_is_dot_gate(C.ConnectionHandle(c.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) IsBarrierGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`IsBarrierGate The connection is closed`)
	}
	val := bool(C.Connection_is_barrier_gate(C.ConnectionHandle(c.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) IsPlungerGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`IsPlungerGate The connection is closed`)
	}
	val := bool(C.Connection_is_plunger_gate(C.ConnectionHandle(c.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) IsReservoirGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`IsReservoirGate The connection is closed`)
	}
	val := bool(C.Connection_is_reservoir_gate(C.ConnectionHandle(c.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) IsScreeningGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`IsScreeningGate The connection is closed`)
	}
	val := bool(C.Connection_is_screening_gate(C.ConnectionHandle(c.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) IsOhmic() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`IsOhmic The connection is closed`)
	}
	val := bool(C.Connection_is_ohmic(C.ConnectionHandle(c.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) IsGate() (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`IsGate The connection is closed`)
	}
	val := bool(C.Connection_is_gate(C.ConnectionHandle(c.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) Equal(other *Handle) (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`Equal The connection is closed`)
	}
	val := bool(C.Connection_equal(C.ConnectionHandle(c.chandle), C.ConnectionHandle(other.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) NotEqual(other *Handle) (bool, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return false, errors.New(`NotEqual The connection is closed`)
	}
	val := bool(C.Connection_not_equal(C.ConnectionHandle(c.chandle), C.ConnectionHandle(other.chandle)))
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (c *Handle) ToJSON() (string, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.closed || c.chandle == utils.NilHandle[connectionHandle]() {
		return "", errors.New(`ToJSON The connection is closed`)
	}
	str, err := stringFromCAPI(unsafe.Pointer(C.Connection_to_json_string(C.ConnectionHandle(c.chandle))))
	if err != nil {
		return "", errors.New(`ToJSON could not convert to a String. ` + err.Error())
	}
	capiErr := c.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer str.Close()
	return str.ToGoString()
}
