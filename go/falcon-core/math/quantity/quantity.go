package quantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/Quantity_c_api.h>
#include <falcon_core/physics/units/SymbolUnit_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type quantityHandle C.QuantityHandle

type Handle struct {
	chandle      quantityHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`CAPIHandle The Quantity is closed`)
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(i quantityHandle) *Handle {
	q := &Handle{chandle: i, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(q, func(_ any) { q.Close() }, true)
	return q
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`QuantityFromCAPI The pointer is null`)
	}
	return new(quantityHandle(p)), nil
}

func New(value float64, unit *symbolunit.Handle) (*Handle, error) {
	var unitHandle C.SymbolUnitHandle
	if unit == nil {
		unitHandle = C.SymbolUnit_create_volt()
	} else {
		capi, err := unit.CAPIHandle()
		if err != nil {
			return nil, errors.Join(errors.New("New construction failed from illegal unit"), err)
		}
		unitHandle = C.SymbolUnitHandle(capi)
	}
	h := quantityHandle(C.Quantity_create(C.double(value), unitHandle))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[quantityHandle]() {
		C.Quantity_destroy(C.QuantityHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[quantityHandle]()
		return nil
	}
	return errors.New("unable to close the Quantity")
}

func (h *Handle) Value() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return 0, errors.New(`Value The Quantity is closed`)
	}
	val := float64(C.Quantity_value(C.QuantityHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) Unit() (*symbolunit.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`Unit The Quantity is closed`)
	}
	unitPtr := unsafe.Pointer(C.Quantity_unit(C.QuantityHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return symbolunit.FromCAPI(unitPtr)
}

func (h *Handle) ConvertTo(target *symbolunit.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return errors.New(`ConvertTo The Quantity is closed`)
	}
	if target == nil {
		return errors.New(`ConvertTo target unit is nil`)
	}
	capi, err := target.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("ConvertTo failed to get CAPI handle for target unit"), err)
	}
	C.Quantity_convert_to(C.QuantityHandle(h.chandle), C.SymbolUnitHandle(capi))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) MultiplyInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`MultiplyInt The Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_multiply_int(C.QuantityHandle(h.chandle), C.int(other)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) MultiplyDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`MultiplyDouble The Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_multiply_double(C.QuantityHandle(h.chandle), C.double(other)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) MultiplyQuantity(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`MultiplyQuantity The Quantity is closed`)
	}
	if other == nil {
		return nil, errors.New(`MultiplyQuantity The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`MultiplyQuantity The other Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_multiply_quantity(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) MultiplyEqualsInt(other int) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`MultiplyEqualsInt The Quantity is closed`)
	}
	C.Quantity_multiply_equals_int(C.QuantityHandle(h.chandle), C.int(other))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return h, nil
}

func (h *Handle) MultiplyEqualsDouble(other float64) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`MultiplyEqualsDouble The Quantity is closed`)
	}
	C.Quantity_multiply_equals_double(C.QuantityHandle(h.chandle), C.double(other))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return h, nil
}

func (h *Handle) MultiplyEqualsQuantity(other *Handle) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`MultiplyEqualsQuantity The Quantity is closed`)
	}
	if other == nil {
		return nil, errors.New(`MultiplyEqualsQuantity The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`MultiplyEqualsQuantity The other Quantity is closed`)
	}
	C.Quantity_multiply_equals_quantity(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return h, nil
}

func (h *Handle) DivideInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`DivideInt The Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_divide_int(C.QuantityHandle(h.chandle), C.int(other)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) DivideDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`DivideDouble The Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_divide_double(C.QuantityHandle(h.chandle), C.double(other)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) DivideQuantity(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`DivideQuantity The Quantity is closed`)
	}
	if other == nil {
		return nil, errors.New(`DivideQuantity The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`DivideQuantity The other Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_divide_quantity(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) DivideEqualsInt(other int) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`DivideEqualsInt The Quantity is closed`)
	}
	C.Quantity_divide_equals_int(C.QuantityHandle(h.chandle), C.int(other))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return h, nil
}

func (h *Handle) DivideEqualsDouble(other float64) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`DivideEqualsDouble The Quantity is closed`)
	}
	C.Quantity_divide_equals_double(C.QuantityHandle(h.chandle), C.double(other))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return h, nil
}

func (h *Handle) DivideEqualsQuantity(other *Handle) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`DivideEqualsQuantity The Quantity is closed`)
	}
	if other == nil {
		return nil, errors.New(`DivideEqualsQuantity The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`DivideEqualsQuantity The other Quantity is closed`)
	}
	C.Quantity_divide_equals_quantity(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return h, nil
}

func (h *Handle) Power(other int32) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`Power The Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_power(C.QuantityHandle(h.chandle), C.int(other)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	if res == nil {
		return nil, errors.New(`Power created a null`)
	}
	return new(res), nil
}

func (h *Handle) AddQuantity(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`AddQuantity The Quantity is closed`)
	}
	if other == nil {
		return nil, errors.New(`AddQuantity The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`AddQuantity The other Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_add_quantity(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) AddEqualsQuantity(other *Handle) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`AddEqualsQuantity The Quantity is closed`)
	}
	if other == nil {
		return nil, errors.New(`AddEqualsQuantity The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`AddEqualsQuantity The other Quantity is closed`)
	}
	C.Quantity_add_equals_quantity(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return h, nil
}

func (h *Handle) SubtractQuantity(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`SubtractQuantity The Quantity is closed`)
	}
	if other == nil {
		return nil, errors.New(`SubtractQuantity The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`SubtractQuantity The other Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_subtract_quantity(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) SubtractEqualsQuantity(other *Handle) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`SubtractEqualsQuantity The Quantity is closed`)
	}
	if other == nil {
		return nil, errors.New(`SubtractEqualsQuantity The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`SubtractEqualsQuantity The other Quantity is closed`)
	}
	C.Quantity_subtract_equals_quantity(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return h, nil
}

func (h *Handle) Negate() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`Negate The Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_negate(C.QuantityHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) Abs() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return nil, errors.New(`Abs The Quantity is closed`)
	}
	res := quantityHandle(C.Quantity_abs(C.QuantityHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return new(res), nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return false, errors.New(`Equal The Quantity is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return false, errors.New(`Equal The other Quantity is closed`)
	}
	val := bool(C.Quantity_equal(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return false, errors.New(`NotEqual The Quantity is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other Quantity is nil`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[quantityHandle]() {
		return false, errors.New(`NotEqual The other Quantity is closed`)
	}
	val := bool(C.Quantity_not_equal(C.QuantityHandle(h.chandle), C.QuantityHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[quantityHandle]() {
		return "", errors.New(`ToJSON The Quantity is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Quantity_to_json_string(C.QuantityHandle(h.chandle))))
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
	h := quantityHandle(C.Quantity_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
