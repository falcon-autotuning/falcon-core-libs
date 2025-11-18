package symbolunit

/*
#cgo pkg-config: falcon_core_c_api
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

var stringFromCAPI = str.FromCAPI

type symbolUnitHandle C.SymbolUnitHandle

type Handle struct {
	chandle      symbolUnitHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (s *Handle) CAPIHandle() (unsafe.Pointer, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	if s.closed || s.chandle == utils.NilHandle[symbolUnitHandle]() {
		return nil, errors.New("Symbol: handle is closed")
	}
	return unsafe.Pointer(s.chandle), nil
}

func new(h symbolUnitHandle) *Handle {
	unit := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(unit, func(u *Handle) { u.Close() })
	return unit
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(symbolUnitHandle(p)), nil
}

// Constructors (all units)
func NewMeter() (*Handle, error)           { return newUnit(C.SymbolUnit_create_meter()) }
func NewKilogram() (*Handle, error)        { return newUnit(C.SymbolUnit_create_kilogram()) }
func NewSecond() (*Handle, error)          { return newUnit(C.SymbolUnit_create_second()) }
func NewAmpere() (*Handle, error)          { return newUnit(C.SymbolUnit_create_ampere()) }
func NewKelvin() (*Handle, error)          { return newUnit(C.SymbolUnit_create_kelvin()) }
func NewMole() (*Handle, error)            { return newUnit(C.SymbolUnit_create_mole()) }
func NewCandela() (*Handle, error)         { return newUnit(C.SymbolUnit_create_candela()) }
func NewHertz() (*Handle, error)           { return newUnit(C.SymbolUnit_create_hertz()) }
func NewNewton() (*Handle, error)          { return newUnit(C.SymbolUnit_create_newton()) }
func NewPascal() (*Handle, error)          { return newUnit(C.SymbolUnit_create_pascal()) }
func NewJoule() (*Handle, error)           { return newUnit(C.SymbolUnit_create_joule()) }
func NewWatt() (*Handle, error)            { return newUnit(C.SymbolUnit_create_watt()) }
func NewCoulomb() (*Handle, error)         { return newUnit(C.SymbolUnit_create_coulomb()) }
func NewVolt() (*Handle, error)            { return newUnit(C.SymbolUnit_create_volt()) }
func NewFarad() (*Handle, error)           { return newUnit(C.SymbolUnit_create_farad()) }
func NewOhm() (*Handle, error)             { return newUnit(C.SymbolUnit_create_ohm()) }
func NewSiemens() (*Handle, error)         { return newUnit(C.SymbolUnit_create_siemens()) }
func NewWeber() (*Handle, error)           { return newUnit(C.SymbolUnit_create_weber()) }
func NewTesla() (*Handle, error)           { return newUnit(C.SymbolUnit_create_tesla()) }
func NewHenry() (*Handle, error)           { return newUnit(C.SymbolUnit_create_henry()) }
func NewMinute() (*Handle, error)          { return newUnit(C.SymbolUnit_create_minute()) }
func NewHour() (*Handle, error)            { return newUnit(C.SymbolUnit_create_hour()) }
func NewElectronvolt() (*Handle, error)    { return newUnit(C.SymbolUnit_create_electronvolt()) }
func NewCelsius() (*Handle, error)         { return newUnit(C.SymbolUnit_create_celsius()) }
func NewFahrenheit() (*Handle, error)      { return newUnit(C.SymbolUnit_create_fahrenheit()) }
func NewDimensionless() (*Handle, error)   { return newUnit(C.SymbolUnit_create_dimensionless()) }
func NewPercent() (*Handle, error)         { return newUnit(C.SymbolUnit_create_percent()) }
func NewRadian() (*Handle, error)          { return newUnit(C.SymbolUnit_create_radian()) }
func NewKilometer() (*Handle, error)       { return newUnit(C.SymbolUnit_create_kilometer()) }
func NewMillimeter() (*Handle, error)      { return newUnit(C.SymbolUnit_create_millimeter()) }
func NewMillivolt() (*Handle, error)       { return newUnit(C.SymbolUnit_create_millivolt()) }
func NewKilovolt() (*Handle, error)        { return newUnit(C.SymbolUnit_create_kilovolt()) }
func NewMilliampere() (*Handle, error)     { return newUnit(C.SymbolUnit_create_milliampere()) }
func NewMicroampere() (*Handle, error)     { return newUnit(C.SymbolUnit_create_microampere()) }
func NewNanoampere() (*Handle, error)      { return newUnit(C.SymbolUnit_create_nanoampere()) }
func NewPicoampere() (*Handle, error)      { return newUnit(C.SymbolUnit_create_picoampere()) }
func NewMillisecond() (*Handle, error)     { return newUnit(C.SymbolUnit_create_millisecond()) }
func NewMicrosecond() (*Handle, error)     { return newUnit(C.SymbolUnit_create_microsecond()) }
func NewNanosecond() (*Handle, error)      { return newUnit(C.SymbolUnit_create_nanosecond()) }
func NewPicosecond() (*Handle, error)      { return newUnit(C.SymbolUnit_create_picosecond()) }
func NewMilliohm() (*Handle, error)        { return newUnit(C.SymbolUnit_create_milliohm()) }
func NewKiloohm() (*Handle, error)         { return newUnit(C.SymbolUnit_create_kiloohm()) }
func NewMegaohm() (*Handle, error)         { return newUnit(C.SymbolUnit_create_megaohm()) }
func NewMillihertz() (*Handle, error)      { return newUnit(C.SymbolUnit_create_millihertz()) }
func NewKilohertz() (*Handle, error)       { return newUnit(C.SymbolUnit_create_kilohertz()) }
func NewMegahertz() (*Handle, error)       { return newUnit(C.SymbolUnit_create_megahertz()) }
func NewGigahertz() (*Handle, error)       { return newUnit(C.SymbolUnit_create_gigahertz()) }
func NewMetersPerSecond() (*Handle, error) { return newUnit(C.SymbolUnit_create_meters_per_second()) }
func NewMetersPerSecondSquared() (*Handle, error) {
	return newUnit(C.SymbolUnit_create_meters_per_second_squared())
}
func NewNewtonMeter() (*Handle, error)     { return newUnit(C.SymbolUnit_create_newton_meter()) }
func NewNewtonsPerMeter() (*Handle, error) { return newUnit(C.SymbolUnit_create_newtons_per_meter()) }
func NewVoltsPerMeter() (*Handle, error)   { return newUnit(C.SymbolUnit_create_volts_per_meter()) }
func NewVoltsPerSecond() (*Handle, error)  { return newUnit(C.SymbolUnit_create_volts_per_second()) }
func NewAmperesPerMeter() (*Handle, error) { return newUnit(C.SymbolUnit_create_amperes_per_meter()) }
func NewVoltsPerAmpere() (*Handle, error)  { return newUnit(C.SymbolUnit_create_volts_per_ampere()) }
func NewWattsPerMeterKelvin() (*Handle, error) {
	return newUnit(C.SymbolUnit_create_watts_per_meter_kelvin())
}

func newUnit(h C.SymbolUnitHandle) (*Handle, error) {
	handle := symbolUnitHandle(h)
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(handle), nil
}

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New(`failed to access capi for json`), err)
	}
	h := symbolUnitHandle(C.SymbolUnit_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (u *Handle) Close() error {
	u.mu.Lock()
	defer u.mu.Unlock()
	if !u.closed && u.chandle != utils.NilHandle[symbolUnitHandle]() {
		C.SymbolUnit_destroy(C.SymbolUnitHandle(u.chandle))
		err := u.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		u.closed = true
		u.chandle = utils.NilHandle[symbolUnitHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

func (u *Handle) Symbol() (string, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return "", errors.New("Symbol: handle is closed")
	}
	s, err := stringFromCAPI(unsafe.Pointer(C.SymbolUnit_symbol(C.SymbolUnitHandle(u.chandle))))
	if err != nil {
		return "", errors.New("Symbol: " + err.Error())
	}
	capiErr := u.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer s.Close()
	return s.ToGoString()
}

func (u *Handle) Name() (string, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return "", errors.New("Name: handle is closed")
	}
	s, err := stringFromCAPI(unsafe.Pointer(C.SymbolUnit_name(C.SymbolUnitHandle(u.chandle))))
	if err != nil {
		return "", errors.New("Name: " + err.Error())
	}
	capiErr := u.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer s.Close()
	return s.ToGoString()
}

func (u *Handle) Multiplication(other *Handle) (*Handle, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return nil, errors.New("Multiplication: handle is closed")
	}
	if other == nil {
		return nil, errors.New(`Multiplication: other handle is nil`)
	}
	if other.closed || other.chandle == utils.NilHandle[symbolUnitHandle]() {
		return nil, errors.New("Multiplication: other handle is closed")
	}
	h := symbolUnitHandle(C.SymbolUnit_multiplication(C.SymbolUnitHandle(u.chandle), C.SymbolUnitHandle(other.chandle)))
	err := u.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (u *Handle) Division(other *Handle) (*Handle, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return nil, errors.New("Division: handle is closed")
	}
	if other == nil {
		return nil, errors.New(`Division: other handle is nil`)
	}
	if other.closed || other.chandle == utils.NilHandle[symbolUnitHandle]() {
		return nil, errors.New("Division: other handle is closed")
	}
	h := symbolUnitHandle(C.SymbolUnit_division(C.SymbolUnitHandle(u.chandle), C.SymbolUnitHandle(other.chandle)))
	err := u.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (u *Handle) Power(power int) (*Handle, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return nil, errors.New("Power: handle is closed")
	}
	h := symbolUnitHandle(C.SymbolUnit_power(C.SymbolUnitHandle(u.chandle), C.int(power)))
	err := u.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (u *Handle) WithPrefix(prefix string) (*Handle, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return nil, errors.New("WithPrefix: handle is closed")
	}
	p := str.New(prefix)
	defer p.Close()
	pcapi, err := p.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("WithPrefix: unable to access capi"), err)
	}
	h := symbolUnitHandle(C.SymbolUnit_with_prefix(C.SymbolUnitHandle(u.chandle), C.StringHandle(pcapi)))
	err = u.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (u *Handle) ConvertValueTo(value float64, target *Handle) (float64, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return 0, errors.New("ConvertValueTo: handle is closed")
	}
	if target == nil {
		return 0, errors.New("ConvertValueTo: target is nil")
	}
	if target.closed || target.chandle == utils.NilHandle[symbolUnitHandle]() {
		return 0, errors.New("ConvertValueTo: target is closed")
	}
	res := float64(C.SymbolUnit_convert_value_to(C.SymbolUnitHandle(u.chandle), C.double(value), C.SymbolUnitHandle(target.chandle)))
	err := u.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return res, nil
}

func (u *Handle) IsCompatibleWith(other *Handle) (bool, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return false, errors.New("IsCompatibleWith: handle is closed")
	}
	if other == nil {
		return false, errors.New("IsCompatibleWith: other handle is nil")
	}
	if other.closed || other.chandle == utils.NilHandle[symbolUnitHandle]() {
		return false, errors.New("IsCompatibleWith: other handle is closed")
	}
	val := bool(C.SymbolUnit_is_compatible_with(C.SymbolUnitHandle(u.chandle), C.SymbolUnitHandle(other.chandle)))
	err := u.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (u *Handle) Equal(other *Handle) (bool, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other handle is nil")
	}
	if other.closed || other.chandle == utils.NilHandle[symbolUnitHandle]() {
		return false, errors.New("Equal: other handle is closed")
	}
	val := bool(C.SymbolUnit_equal(C.SymbolUnitHandle(u.chandle), C.SymbolUnitHandle(other.chandle)))
	err := u.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (u *Handle) NotEqual(other *Handle) (bool, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other handle is nil")
	}
	if other.closed || other.chandle == utils.NilHandle[symbolUnitHandle]() {
		return false, errors.New("NotEqual: other handle is closed")
	}
	val := bool(C.SymbolUnit_not_equal(C.SymbolUnitHandle(u.chandle), C.SymbolUnitHandle(other.chandle)))
	err := u.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (u *Handle) ToJSON() (string, error) {
	u.mu.RLock()
	defer u.mu.RUnlock()
	if u.closed || u.chandle == utils.NilHandle[symbolUnitHandle]() {
		return "", errors.New("ToJSON: handle is closed")
	}
	s, err := stringFromCAPI(unsafe.Pointer(C.SymbolUnit_to_json_string(C.SymbolUnitHandle(u.chandle))))
	if err != nil {
		return "", errors.New("ToJSON: " + err.Error())
	}
	capiErr := u.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer s.Close()
	return s.ToGoString()
}
