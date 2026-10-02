package access

/*
#cgo pkg-config: falcon-core-c-api
#include <falcon-core/instrument_interfaces/names/InstrumentPort_c_api.h>
*/
import "C"

type Access int32

const (
	Read      Access = Access(C.ACCESS_READ)
	Write     Access = Access(C.ACCESS_WRITE)
	Readwrite Access = Access(C.ACCESS_READWRITE)
)

func (v Access) String() string {
	switch v {
	case Read:
		return "Read"
	case Write:
		return "Write"
	case Readwrite:
		return "Readwrite"

	default:
		return "Unknown"
	}
}
