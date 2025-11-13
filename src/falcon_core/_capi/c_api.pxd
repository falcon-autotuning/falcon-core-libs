# Low-level C API declarations for falcon-core device structures
# This file declares the C functions exposed by the C API header so Cython
# can call them directly. Keep these declarations minimal and matching the
# real C header.
ctypedef void* ConnectionHandle

cdef extern from "falcon_core/physics/device_structures/Connection_c_api.h":
    ConnectionHandle Connection_create_barrier_gate(const char* name)
    ConnectionHandle Connection_create_plunger_gate(const char* name)
    ConnectionHandle Connection_create_reservoir_gate(const char* name)
    ConnectionHandle Connection_create_screening_gate(const char* name)
    ConnectionHandle Connection_create_ohmic(const char* name)
    ConnectionHandle Connection_from_json_string(const char* json)
    void Connection_destroy(ConnectionHandle handle)
    const char* Connection_name(ConnectionHandle handle)
    const char* Connection_type(ConnectionHandle handle)
    int Connection_is_dot_gate(ConnectionHandle handle)
    int Connection_is_barrier_gate(ConnectionHandle handle)
    int Connection_is_plunger_gate(ConnectionHandle handle)
    int Connection_is_reservoir_gate(ConnectionHandle handle)
    int Connection_is_screening_gate(ConnectionHandle handle)
    int Connection_is_ohmic(ConnectionHandle handle)
    int Connection_is_gate(ConnectionHandle handle)
    int Connection_equal(ConnectionHandle a, ConnectionHandle b)
    int Connection_not_equal(ConnectionHandle a, ConnectionHandle b)
    const char* Connection_to_json_string(ConnectionHandle handle)
