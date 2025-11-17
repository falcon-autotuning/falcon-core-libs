package sign

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/Sign_c_api.h>
*/
import "C"

// Positive returns the integer value for the positive sign.
func Positive() int {
	return int(C.Sign_positive())
}

// Negative returns the integer value for the negative sign.
func Negative() int {
	return int(C.Sign_negative())
}
