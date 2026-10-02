package instrument

/*
#cgo pkg-config: falcon-core-c-api
#include <falcon-core/instrument_interfaces/names/InstrumentPort_c_api.h>
*/
import "C"

type Instrument int32

const (
	DcVoltageSource Instrument = Instrument(C.INSTRUMENT_DC_VOLTAGE_SOURCE)
	Amnmeter        Instrument = Instrument(C.INSTRUMENT_AMNMETER)
	Magnet          Instrument = Instrument(C.INSTRUMENT_MAGNET)
	Lockin          Instrument = Instrument(C.INSTRUMENT_LOCKIN)
	VoltageSource   Instrument = Instrument(C.INSTRUMENT_VOLTAGE_SOURCE)
	CurrentSource   Instrument = Instrument(C.INSTRUMENT_CURRENT_SOURCE)
	HfVoltageSource Instrument = Instrument(C.INSTRUMENT_HF_VOLTAGE_SOURCE)
	DcCurrentSource Instrument = Instrument(C.INSTRUMENT_DC_CURRENT_SOURCE)
	HfCurrentSource Instrument = Instrument(C.INSTRUMENT_HF_CURRENT_SOURCE)
	Thermometer     Instrument = Instrument(C.INSTRUMENT_THERMOMETER)
	Voltmeter       Instrument = Instrument(C.INSTRUMENT_VOLTMETER)
	Fpga            Instrument = Instrument(C.INSTRUMENT_FPGA)
	Clock           Instrument = Instrument(C.INSTRUMENT_CLOCK)
	Discrete        Instrument = Instrument(C.INSTRUMENT_DISCRETE)
)

func (v Instrument) String() string {
	switch v {
	case DcVoltageSource:
		return "DcVoltageSource"
	case Amnmeter:
		return "Amnmeter"
	case Magnet:
		return "Magnet"
	case Lockin:
		return "Lockin"
	case VoltageSource:
		return "VoltageSource"
	case CurrentSource:
		return "CurrentSource"
	case HfVoltageSource:
		return "HfVoltageSource"
	case DcCurrentSource:
		return "DcCurrentSource"
	case HfCurrentSource:
		return "HfCurrentSource"
	case Thermometer:
		return "Thermometer"
	case Voltmeter:
		return "Voltmeter"
	case Fpga:
		return "Fpga"
	case Clock:
		return "Clock"
	case Discrete:
		return "Discrete"

	default:
		return "Unknown"
	}
}
