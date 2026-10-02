package porttype

/*
#cgo pkg-config: falcon-core-c-api
#include <falcon-core/instrument_interfaces/names/InstrumentPort_c_api.h>
*/
import "C"

type PortType int32

const (
	PortTypeKnob    PortType = PortType(C.PORT_TYPE_KNOB)
	PortTypeMeter   PortType = PortType(C.PORT_TYPE_METER)
	PortTypeSetting PortType = PortType(C.PORT_TYPE_SETTING)
)

func (v PortType) String() string {
	switch v {
	case PortTypeKnob:
		return "PortTypeKnob"
	case PortTypeMeter:
		return "PortTypeMeter"
	case PortTypeSetting:
		return "PortTypeSetting"

	default:
		return "Unknown"
	}
}
