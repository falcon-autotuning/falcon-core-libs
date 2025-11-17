package instrumenttypes

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/instrument_interfaces/names/InstrumentTypes_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)

// Helper to convert a C StringHandle to Go string and close it
func cStringHandleToGoString(h C.StringHandle) string {
	s, _ := str.FromCAPI(unsafe.Pointer(h))
	defer s.Close()
	val, _ := s.ToGoString()
	return val
}

func DCVoltageSource() string {
	return cStringHandleToGoString(C.InstrumentTypes_dc_voltage_source())
}

func Amnmeter() string {
	return cStringHandleToGoString(C.InstrumentTypes_amnmeter())
}

func Magnet() string {
	return cStringHandleToGoString(C.InstrumentTypes_magnet())
}

func Lockin() string {
	return cStringHandleToGoString(C.InstrumentTypes_lockin())
}

func VoltageSource() string {
	return cStringHandleToGoString(C.InstrumentTypes_voltage_source())
}

func CurrentSource() string {
	return cStringHandleToGoString(C.InstrumentTypes_current_source())
}

func HFVoltageSource() string {
	return cStringHandleToGoString(C.InstrumentTypes_hf_voltage_source())
}

func DCCurrentSource() string {
	return cStringHandleToGoString(C.InstrumentTypes_dc_current_source())
}

func HFCurrentSource() string {
	return cStringHandleToGoString(C.InstrumentTypes_hf_current_source())
}

func Thermometer() string {
	return cStringHandleToGoString(C.InstrumentTypes_thermometer())
}

func Voltmeter() string {
	return cStringHandleToGoString(C.InstrumentTypes_voltmeter())
}

func FPGA() string {
	return cStringHandleToGoString(C.InstrumentTypes_fpga())
}

func Clock() string {
	return cStringHandleToGoString(C.InstrumentTypes_clock())
}

func Discrete() string {
	return cStringHandleToGoString(C.InstrumentTypes_discrete())
}
