package instrumentcharacteristic

/*
#cgo pkg-config: falcon-core-c-api
#include <falcon-core/instrument_interfaces/names/InstrumentPort_c_api.h>
*/
import "C"

type InstrumentCharacteristic int32

const (
	InstrumentCharacteristicNone                InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_NONE)
	InstrumentCharacteristicSampleRate          InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_SAMPLE_RATE)
	InstrumentCharacteristicMaxSampleRate       InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_SAMPLE_RATE)
	InstrumentCharacteristicMinSampleRate       InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_SAMPLE_RATE)
	InstrumentCharacteristicAppliedVoltage      InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_APPLIED_VOLTAGE)
	InstrumentCharacteristicMaxSourceVoltage    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_SOURCE_VOLTAGE)
	InstrumentCharacteristicMinSourceVoltage    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_SOURCE_VOLTAGE)
	InstrumentCharacteristicNumberOfSamples     InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_NUMBER_OF_SAMPLES)
	InstrumentCharacteristicMaxNumberOfSamples  InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_NUMBER_OF_SAMPLES)
	InstrumentCharacteristicMinNumberOfSamples  InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_NUMBER_OF_SAMPLES)
	InstrumentCharacteristicVoltageRampSlope    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_VOLTAGE_RAMP_SLOPE)
	InstrumentCharacteristicMaxVoltageRampSlope InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_VOLTAGE_RAMP_SLOPE)
	InstrumentCharacteristicMinVoltageRampSlope InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_VOLTAGE_RAMP_SLOPE)
	InstrumentCharacteristicTemperature         InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_TEMPERATURE)
	InstrumentCharacteristicMagnetStrength      InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAGNET_STRENGTH)
)

func (v InstrumentCharacteristic) String() string {
	switch v {
	case InstrumentCharacteristicNone:
		return "InstrumentCharacteristicNone"
	case InstrumentCharacteristicSampleRate:
		return "InstrumentCharacteristicSampleRate"
	case InstrumentCharacteristicMaxSampleRate:
		return "InstrumentCharacteristicMaxSampleRate"
	case InstrumentCharacteristicMinSampleRate:
		return "InstrumentCharacteristicMinSampleRate"
	case InstrumentCharacteristicAppliedVoltage:
		return "InstrumentCharacteristicAppliedVoltage"
	case InstrumentCharacteristicMaxSourceVoltage:
		return "InstrumentCharacteristicMaxSourceVoltage"
	case InstrumentCharacteristicMinSourceVoltage:
		return "InstrumentCharacteristicMinSourceVoltage"
	case InstrumentCharacteristicNumberOfSamples:
		return "InstrumentCharacteristicNumberOfSamples"
	case InstrumentCharacteristicMaxNumberOfSamples:
		return "InstrumentCharacteristicMaxNumberOfSamples"
	case InstrumentCharacteristicMinNumberOfSamples:
		return "InstrumentCharacteristicMinNumberOfSamples"
	case InstrumentCharacteristicVoltageRampSlope:
		return "InstrumentCharacteristicVoltageRampSlope"
	case InstrumentCharacteristicMaxVoltageRampSlope:
		return "InstrumentCharacteristicMaxVoltageRampSlope"
	case InstrumentCharacteristicMinVoltageRampSlope:
		return "InstrumentCharacteristicMinVoltageRampSlope"
	case InstrumentCharacteristicTemperature:
		return "InstrumentCharacteristicTemperature"
	case InstrumentCharacteristicMagnetStrength:
		return "InstrumentCharacteristicMagnetStrength"

	default:
		return "Unknown"
	}
}
