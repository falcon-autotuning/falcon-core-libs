from libc.stddef cimport size_t

# Define types and functions from the String C API header.
# Placing the struct definition inside this block tells Cython
# that it's the same struct defined in the C header.
cdef extern from "falcon_core/generic/String_c_api.h":
    ctypedef struct string:
        char *raw
        size_t length

    ctypedef string * StringHandle

    StringHandle String_create(const char* raw, size_t length)
    StringHandle String_wrap(const char* raw)
    void String_destroy(StringHandle handle)

# Define types and functions from the Connection C API header.
cdef extern from "falcon_core/physics/device_structures/Connection_c_api.h":
    ctypedef void * ConnectionHandle

    ConnectionHandle Connection_create_barrier_gate(StringHandle name)
    ConnectionHandle Connection_create_plunger_gate(StringHandle name)
    ConnectionHandle Connection_create_reservoir_gate(StringHandle name)
    ConnectionHandle Connection_create_screening_gate(StringHandle name)
    ConnectionHandle Connection_create_ohmic(StringHandle name)
    ConnectionHandle Connection_from_json_string(StringHandle json)
    void Connection_destroy(ConnectionHandle handle)

    StringHandle Connection_name(ConnectionHandle handle)
    StringHandle Connection_type(ConnectionHandle handle)
    int Connection_is_dot_gate(ConnectionHandle handle)
    int Connection_is_barrier_gate(ConnectionHandle handle)
    int Connection_is_plunger_gate(ConnectionHandle handle)
    int Connection_is_reservoir_gate(ConnectionHandle handle)
    int Connection_is_screening_gate(ConnectionHandle handle)
    int Connection_is_ohmic(ConnectionHandle handle)
    int Connection_is_gate(ConnectionHandle handle)
    int Connection_equal(ConnectionHandle a, ConnectionHandle b)
    int Connection_not_equal(ConnectionHandle a, ConnectionHandle b)
    StringHandle Connection_to_json_string(ConnectionHandle handle)
