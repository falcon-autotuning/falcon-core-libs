//go:build linux
// +build linux

package connection

/*
  #cgo CFLAGS: -I/usr/local/include/falcon-core-c-api
  #cgo LDFLAGS: -L/usr/local/lib -lfalcon_core_c_api
  #include <falcon_core/physics/device_structures/Connection_c_api.h>
	#include <falcon_core/generic/String_c_api.h>
  #include <stdlib.h>
*/
import "C"
import "unsafe"

type connectionHandle C.ConnectionHandle

func cStringToGoString(raw *C.char, length C.ulong) string {
	return string(C.GoBytes(unsafe.Pointer(raw), C.int(length)))
}

func nilHandle() connectionHandle { return nil }

func createBarrierGate(name string) connectionHandle {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	return connectionHandle(C.Connection_create_barrier_gate(realName))
}

func createPlungerGate(name string) connectionHandle {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	return connectionHandle(C.Connection_create_plunger_gate(realName))
}

func createReservoirGate(name string) connectionHandle {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	return connectionHandle(C.Connection_create_reservoir_gate(realName))
}

func createScreeningGate(name string) connectionHandle {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	return connectionHandle(C.Connection_create_screening_gate(realName))
}

func createOhmic(name string) connectionHandle {
	cname := C.CString(name)
	defer C.free(unsafe.Pointer(cname))
	realName := C.String_wrap(cname)
	defer C.String_destroy(realName)
	return connectionHandle(C.Connection_create_ohmic(realName))
}

func fromJSON(json string) connectionHandle {
	cjson := C.CString(json)
	defer C.free(unsafe.Pointer(cjson))
	realJSON := C.String_wrap(cjson)
	defer C.String_destroy(realJSON)
	return connectionHandle(C.Connection_from_json_string(realJSON))
}

func destroy(h connectionHandle) {
	C.Connection_destroy(C.ConnectionHandle(h))
}

func name(h connectionHandle) string {
	sh := C.Connection_name(C.ConnectionHandle(h))
	defer C.String_destroy(sh)
	return cStringToGoString(sh.raw, sh.length)
}

func connectionType(h connectionHandle) string {
	sh := C.Connection_type(C.ConnectionHandle(h))
	defer C.String_destroy(sh)
	return cStringToGoString(sh.raw, sh.length)
}

func isDotGate(h connectionHandle) bool {
	return bool(C.Connection_is_dot_gate(C.ConnectionHandle(h)))
}

func isBarrierGate(h connectionHandle) bool {
	return bool(C.Connection_is_barrier_gate(C.ConnectionHandle(h)))
}

func isPlungerGate(h connectionHandle) bool {
	return bool(C.Connection_is_plunger_gate(C.ConnectionHandle(h)))
}

func isReservoirGate(h connectionHandle) bool {
	return bool(C.Connection_is_reservoir_gate(C.ConnectionHandle(h)))
}

func isScreeningGate(h connectionHandle) bool {
	return bool(C.Connection_is_screening_gate(C.ConnectionHandle(h)))
}

func isOhmic(h connectionHandle) bool {
	return bool(C.Connection_is_ohmic(C.ConnectionHandle(h)))
}

func isGate(h connectionHandle) bool {
	return bool(C.Connection_is_gate(C.ConnectionHandle(h)))
}

func equal(a, b connectionHandle) bool {
	return bool(C.Connection_equal(C.ConnectionHandle(a), C.ConnectionHandle(b)))
}

func notEqual(a, b connectionHandle) bool {
	return bool(C.Connection_not_equal(C.ConnectionHandle(a), C.ConnectionHandle(b)))
}

func toJSON(h connectionHandle) string {
	sh := C.Connection_to_json_string(C.ConnectionHandle(h))
	defer C.String_destroy(sh)
	return cStringToGoString(sh.raw, sh.length)
}
