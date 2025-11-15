package utils

import (
	"unsafe"
)

// CStringToGoString Converts a C string with known length to a Go string.
func CStringToGoString(ptr unsafe.Pointer, length int) string {
	return string(unsafe.Slice((*byte)(ptr), length))
}

func NilHandle[T any]() T {
	var zero T
	return zero
}
