package utils

import (
	"C"
)

func NilHandle[T any]() T {
	var zero T
	return zero
}
