package scope

/*
#cgo pkg-config: falcon-core-c-api
#include <falcon-core/instrument_interfaces/names/InstrumentPort_c_api.h>
*/
import "C"

type Scope int32

const (
	Local  Scope = Scope(C.SCOPE_LOCAL)
	Global Scope = Scope(C.SCOPE_GLOBAL)
)

func (v Scope) String() string {
	switch v {
	case Local:
		return "Local"
	case Global:
		return "Global"

	default:
		return "Unknown"
	}
}
