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
	InstrumentCharacteristicSourceVoltage       InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_SOURCE_VOLTAGE)
	InstrumentCharacteristicMaxSourceVoltage    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_SOURCE_VOLTAGE)
	InstrumentCharacteristicMinSourceVoltage    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_SOURCE_VOLTAGE)
	InstrumentCharacteristicVoltageRampSlope    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_VOLTAGE_RAMP_SLOPE)
	InstrumentCharacteristicMaxVoltageRampSlope InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_VOLTAGE_RAMP_SLOPE)
	InstrumentCharacteristicMinVoltageRampSlope InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_VOLTAGE_RAMP_SLOPE)
	InstrumentCharacteristicSourceCurrent       InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_SOURCE_CURRENT)
	InstrumentCharacteristicMaxSourceCurrent    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_SOURCE_CURRENT)
	InstrumentCharacteristicMinSourceCurrent    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_SOURCE_CURRENT)
	InstrumentCharacteristicCurrentRampSlope    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_CURRENT_RAMP_SLOPE)
	InstrumentCharacteristicMaxCurrentRampSlope InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_CURRENT_RAMP_SLOPE)
	InstrumentCharacteristicMinCurrentRampSlope InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_CURRENT_RAMP_SLOPE)
	InstrumentCharacteristicSourceFrequency     InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_SOURCE_FREQUENCY)
	InstrumentCharacteristicMaxSourceFrequency  InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_SOURCE_FREQUENCY)
	InstrumentCharacteristicMinSourceFrequency  InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_SOURCE_FREQUENCY)
	InstrumentCharacteristicSinkFrequency       InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_SINK_FREQUENCY)
	InstrumentCharacteristicMaxSinkFrequency    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_SINK_FREQUENCY)
	InstrumentCharacteristicMinSinkFrequency    InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_SINK_FREQUENCY)
	InstrumentCharacteristicAcAmplitude         InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_AC_AMPLITUDE)
	InstrumentCharacteristicMaxAcAmplitude      InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_AC_AMPLITUDE)
	InstrumentCharacteristicMinAcAmplitude      InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_AC_AMPLITUDE)
	InstrumentCharacteristicNumberOfSamples     InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_NUMBER_OF_SAMPLES)
	InstrumentCharacteristicMaxNumberOfSamples  InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_NUMBER_OF_SAMPLES)
	InstrumentCharacteristicMinNumberOfSamples  InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_NUMBER_OF_SAMPLES)
	InstrumentCharacteristicTemperature         InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_TEMPERATURE)
	InstrumentCharacteristicMagnetStrength      InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAGNET_STRENGTH)
	InstrumentCharacteristicMaxMagnetStrength   InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MAX_MAGNET_STRENGTH)
	InstrumentCharacteristicMinMagnetStrength   InstrumentCharacteristic = InstrumentCharacteristic(C.INSTRUMENT_CHARACTERISTIC_MIN_MAGNET_STRENGTH)
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
	case InstrumentCharacteristicSourceVoltage:
		return "InstrumentCharacteristicSourceVoltage"
	case InstrumentCharacteristicMaxSourceVoltage:
		return "InstrumentCharacteristicMaxSourceVoltage"
	case InstrumentCharacteristicMinSourceVoltage:
		return "InstrumentCharacteristicMinSourceVoltage"
	case InstrumentCharacteristicVoltageRampSlope:
		return "InstrumentCharacteristicVoltageRampSlope"
	case InstrumentCharacteristicMaxVoltageRampSlope:
		return "InstrumentCharacteristicMaxVoltageRampSlope"
	case InstrumentCharacteristicMinVoltageRampSlope:
		return "InstrumentCharacteristicMinVoltageRampSlope"
	case InstrumentCharacteristicSourceCurrent:
		return "InstrumentCharacteristicSourceCurrent"
	case InstrumentCharacteristicMaxSourceCurrent:
		return "InstrumentCharacteristicMaxSourceCurrent"
	case InstrumentCharacteristicMinSourceCurrent:
		return "InstrumentCharacteristicMinSourceCurrent"
	case InstrumentCharacteristicCurrentRampSlope:
		return "InstrumentCharacteristicCurrentRampSlope"
	case InstrumentCharacteristicMaxCurrentRampSlope:
		return "InstrumentCharacteristicMaxCurrentRampSlope"
	case InstrumentCharacteristicMinCurrentRampSlope:
		return "InstrumentCharacteristicMinCurrentRampSlope"
	case InstrumentCharacteristicSourceFrequency:
		return "InstrumentCharacteristicSourceFrequency"
	case InstrumentCharacteristicMaxSourceFrequency:
		return "InstrumentCharacteristicMaxSourceFrequency"
	case InstrumentCharacteristicMinSourceFrequency:
		return "InstrumentCharacteristicMinSourceFrequency"
	case InstrumentCharacteristicSinkFrequency:
		return "InstrumentCharacteristicSinkFrequency"
	case InstrumentCharacteristicMaxSinkFrequency:
		return "InstrumentCharacteristicMaxSinkFrequency"
	case InstrumentCharacteristicMinSinkFrequency:
		return "InstrumentCharacteristicMinSinkFrequency"
	case InstrumentCharacteristicAcAmplitude:
		return "InstrumentCharacteristicAcAmplitude"
	case InstrumentCharacteristicMaxAcAmplitude:
		return "InstrumentCharacteristicMaxAcAmplitude"
	case InstrumentCharacteristicMinAcAmplitude:
		return "InstrumentCharacteristicMinAcAmplitude"
	case InstrumentCharacteristicNumberOfSamples:
		return "InstrumentCharacteristicNumberOfSamples"
	case InstrumentCharacteristicMaxNumberOfSamples:
		return "InstrumentCharacteristicMaxNumberOfSamples"
	case InstrumentCharacteristicMinNumberOfSamples:
		return "InstrumentCharacteristicMinNumberOfSamples"
	case InstrumentCharacteristicTemperature:
		return "InstrumentCharacteristicTemperature"
	case InstrumentCharacteristicMagnetStrength:
		return "InstrumentCharacteristicMagnetStrength"
	case InstrumentCharacteristicMaxMagnetStrength:
		return "InstrumentCharacteristicMaxMagnetStrength"
	case InstrumentCharacteristicMinMagnetStrength:
		return "InstrumentCharacteristicMinMagnetStrength"

	default:
		return "Unknown"
	}
}
