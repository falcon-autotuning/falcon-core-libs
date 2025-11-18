package domain

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/domains/Domain_c_api.h>
#include <falcon_core/generic/String_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type domainHandle C.DomainHandle

type Handle struct {
	chandle      domainHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

// CAPIHandle provides access to the underlying CAPI handle for the Domain
func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return nil, errors.New(`CAPIHandle The Domain is closed`)
	}
	return unsafe.Pointer(h.chandle), nil
}

// new adds an auto cleanup whenever added to a constructor
func new(i domainHandle) *Handle {
	d := &Handle{chandle: i, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(d, func(_ any) { d.Close() }, true)
	return d
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`DomainFromCAPI The pointer is null`)
	}
	return new(domainHandle(p)), nil
}

// New creates a new Domain
func New(minVal, maxVal float64, lesserBoundContained, greaterBoundContained bool) (*Handle, error) {
	h := domainHandle(C.Domain_create(
		C.double(minVal),
		C.double(maxVal),
		C.bool(lesserBoundContained),
		C.bool(greaterBoundContained),
	))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[domainHandle]() {
		C.Domain_destroy(C.DomainHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[domainHandle]()
		return nil
	}
	return errors.New("unable to close the Domain")
}

func (h *Handle) LesserBound() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return 0, errors.New(`LesserBound The Domain is closed`)
	}
	val := float64(C.Domain_lesser_bound(C.DomainHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) GreaterBound() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return 0, errors.New(`GreaterBound The Domain is closed`)
	}
	val := float64(C.Domain_greater_bound(C.DomainHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) LesserBoundContained() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`LesserBoundContained The Domain is closed`)
	}
	val := bool(C.Domain_lesser_bound_contained(C.DomainHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) GreaterBoundContained() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`GreaterBoundContained The Domain is closed`)
	}
	val := bool(C.Domain_greater_bound_contained(C.DomainHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) In(value float64) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`In The Domain is closed`)
	}
	val := bool(C.Domain_in(C.DomainHandle(h.chandle), C.double(value)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) Range() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return 0, errors.New(`Range The Domain is closed`)
	}
	val := float64(C.Domain_range(C.DomainHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) Center() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return 0, errors.New(`Center The Domain is closed`)
	}
	val := float64(C.Domain_center(C.DomainHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return nil, errors.New(`Intersection The Domain is closed`)
	}
	if other == nil {
		return nil, errors.New(`Intersection The other Domain is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[domainHandle]() {
		return nil, errors.New(`Intersection The other Domain is closed`)
	}
	res := domainHandle(C.Domain_intersection(C.DomainHandle(h.chandle), C.DomainHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) Union(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return nil, errors.New(`Union The Domain is closed`)
	}
	if other == nil {
		return nil, errors.New(`Union The other Domain is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[domainHandle]() {
		return nil, errors.New(`Union The other Domain is closed`)
	}
	res := domainHandle(C.Domain_union(C.DomainHandle(h.chandle), C.DomainHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) IsEmpty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`IsEmpty The Domain is closed`)
	}
	val := bool(C.Domain_is_empty(C.DomainHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ContainsDomain(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`ContainsDomain The Domain is closed`)
	}
	if other == nil {
		return false, errors.New(`ContainsDomain The other Domain is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`ContainsDomain The other Domain is closed`)
	}
	val := bool(C.Domain_contains_domain(C.DomainHandle(h.chandle), C.DomainHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) Shift(offset float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return nil, errors.New(`Shift The Domain is closed`)
	}
	res := domainHandle(C.Domain_shift(C.DomainHandle(h.chandle), C.double(offset)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) Scale(scale float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return nil, errors.New(`Scale The Domain is closed`)
	}
	res := domainHandle(C.Domain_scale(C.DomainHandle(h.chandle), C.double(scale)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) Transform(other *Handle, value float64) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return 0, errors.New(`Transform The Domain is closed`)
	}
	if other == nil {
		return 0, errors.New(`Transform The other Domain is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[domainHandle]() {
		return 0, errors.New(`Transform The other Domain is closed`)
	}
	val := float64(C.Domain_transform(C.DomainHandle(h.chandle), C.DomainHandle(other.chandle), C.double(value)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`Equal The Domain is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other Domain is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`Equal The other Domain is closed`)
	}
	val := bool(C.Domain_equal(C.DomainHandle(h.chandle), C.DomainHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`NotEqual The Domain is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other Domain is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[domainHandle]() {
		return false, errors.New(`NotEqual The other Domain is closed`)
	}
	val := bool(C.Domain_not_equal(C.DomainHandle(h.chandle), C.DomainHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[domainHandle]() {
		return "", errors.New(`ToJSON The Domain is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Domain_to_json_string(C.DomainHandle(h.chandle))))
	if err != nil {
		return "", errors.New(`ToJSON could not convert to a String. ` + err.Error())
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
		return nil, errors.Join(errors.New(`failed to access capi for json`), err)
	}
	h := domainHandle(C.Domain_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
