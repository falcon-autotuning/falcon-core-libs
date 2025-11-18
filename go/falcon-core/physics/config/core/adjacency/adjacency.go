package adjacency

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farrayint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairsizetsizet"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/core/Adjacency_c_api.h>
#include <falcon_core/generic/FArrayInt_c_api.h>
#include <falcon_core/generic/ListListSizeT_c_api.h>
#include <falcon_core/generic/ListPairSizeTSizeT_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/physics/device_structures/Connections_c_api.h>
#include <stdlib.h>
*/
import "C"

type chandle C.AdjacencyHandle

type Handle struct {
	chandle      chandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[chandle]() {
		return nil, errors.New("CAPIHandle: Adjacency is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(h chandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(handle, func(_ any) { handle.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is null")
	}
	return new(chandle(p)), nil
}

func Create(data []int, shape []int, indexes *connections.Handle) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	cdata := make([]C.int, len(data))
	for i, v := range data {
		cdata[i] = C.int(v)
	}
	if indexes == nil {
		return nil, errors.New(`cannot create adjacency from nil connections`)
	}
	capiIndexes, err := indexes.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.Adjacency_create(&cdata[0], &cshape[0], C.size_t(len(shape)), C.ConnectionsHandle(capiIndexes)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("failed to access capi for json"), err)
	}
	h := chandle(C.Adjacency_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != nil {
		C.Adjacency_destroy(C.AdjacencyHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = nil
		return nil
	}
	return errors.New("unable to close the Handle")
}

func (h *Handle) Indexes() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.Adjacency_indexes(C.AdjacencyHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetTruePairs() (*listpairsizetsizet.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.Adjacency_get_true_pairs(C.AdjacencyHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listpairsizetsizet.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := int(C.Adjacency_size(C.AdjacencyHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Dimension() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := int(C.Adjacency_dimension(C.AdjacencyHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Shape() ([]int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Shape: Adjacency is closed")
	}
	ndim := int(C.Adjacency_dimension(C.AdjacencyHandle(h.chandle)))
	if ndim == 0 {
		return nil, errors.New("Shape: dimension is zero")
	}
	out := make([]C.size_t, ndim)
	C.Adjacency_shape(C.AdjacencyHandle(h.chandle), &out[0], C.size_t(ndim))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	shape := make([]int, ndim)
	for i := range out {
		shape[i] = int(out[i])
	}
	return shape, nil
}

func (h *Handle) Data() ([]int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Data: Adjacency is closed")
	}
	size := int(C.Adjacency_size(C.AdjacencyHandle(h.chandle)))
	if size == 0 {
		return nil, errors.New("Data: size is zero")
	}
	out := make([]C.int, size)
	C.Adjacency_data(C.AdjacencyHandle(h.chandle), &out[0], C.size_t(size))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	data := make([]int, size)
	for i := range out {
		data[i] = int(out[i])
	}
	return data, nil
}

func (h *Handle) TimesEqualsFArray(other *farrayint.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if other == nil {
		return errors.New(`TimesEqualsFArray: the other array was nil`)
	}
	capiarray, err := other.CAPIHandle()
	if err != nil {
		return err
	}
	C.Adjacency_timesequals_farray(C.AdjacencyHandle(h.chandle), C.FArrayIntHandle(capiarray))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) TimesFArray(other *farrayint.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New(`TimesFArray: the other array was nil`)
	}
	capiarray, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.Adjacency_times_farray(C.AdjacencyHandle(h.chandle), C.FArrayIntHandle(capiarray)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Adjacency_equality(C.AdjacencyHandle(h.chandle), C.AdjacencyHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Adjacency_notequality(C.AdjacencyHandle(h.chandle), C.AdjacencyHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Sum() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := int(C.Adjacency_sum(C.AdjacencyHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Where(value int) (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.Adjacency_where(C.AdjacencyHandle(h.chandle), C.int(value))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return unsafe.Pointer(res), nil
}

func (h *Handle) Flip(axis int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := chandle(C.Adjacency_flip(C.AdjacencyHandle(h.chandle), C.size_t(axis)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: Adjacency is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Adjacency_to_json_string(C.AdjacencyHandle(h.chandle))))
	if err != nil {
		return "", errors.New("ToJSON could not convert to a String. " + err.Error())
	}
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}
