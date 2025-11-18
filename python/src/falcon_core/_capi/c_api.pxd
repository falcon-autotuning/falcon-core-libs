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

# Define types and functions from the ListInt C API header.
cdef extern from "falcon_core/generic/ListInt_c_api.h":
    ctypedef void* ListIntHandle

    ListIntHandle ListInt_create_empty()
    ListIntHandle ListInt_create(int* data, size_t count)
    void ListInt_destroy(ListIntHandle handle)
    void ListInt_push_back(ListIntHandle handle, int value)
    void ListInt_erase_at(ListIntHandle handle, size_t idx)
    void ListInt_clear(ListIntHandle handle)
    size_t ListInt_size(ListIntHandle handle)
    int ListInt_at(ListIntHandle handle, size_t idx)
    int ListInt_equal(ListIntHandle a, ListIntHandle b)
    ListIntHandle ListInt_intersection(ListIntHandle handle, ListIntHandle other)
    StringHandle ListInt_to_json_string(ListIntHandle handle)
    ListIntHandle ListInt_from_json_string(StringHandle json)

# Define types and functions from the ListConnection C API header.
cdef extern from "falcon_core/generic/ListConnection_c_api.h":
    ctypedef void* ListConnectionHandle

    ListConnectionHandle ListConnection_create_empty()
    void ListConnection_destroy(ListConnectionHandle handle)
    void ListConnection_push_back(ListConnectionHandle handle, ConnectionHandle value)
    size_t ListConnection_size(ListConnectionHandle handle)
    ConnectionHandle ListConnection_at(ListConnectionHandle handle, size_t idx)
    int ListConnection_equal(ListConnectionHandle a, ListConnectionHandle b)
    ListConnectionHandle ListConnection_intersection(ListConnectionHandle handle, ListConnectionHandle other)

# Define types and functions from the Impedance C API.
cdef extern from "falcon_core/physics/device_structures/Impedance_c_api.h":
    ctypedef void* ImpedanceHandle

    # Constructors / destructor
    ImpedanceHandle Impedance_create(ConnectionHandle connection,
                                     double resistance,
                                     double capacitance)
    void Impedance_destroy(ImpedanceHandle handle)

    # Methods
    ConnectionHandle Impedance_connection(ImpedanceHandle handle)
    double           Impedance_resistance(ImpedanceHandle handle)
    double           Impedance_capacitance(ImpedanceHandle handle)
    int              Impedance_equal(ImpedanceHandle a, ImpedanceHandle b)
    int              Impedance_not_equal(ImpedanceHandle a, ImpedanceHandle b)

    # Serialization
    StringHandle     Impedance_to_json_string(ImpedanceHandle handle)
    ImpedanceHandle  Impedance_from_json_string(StringHandle json)

# Define types and functions from the Connections C API.
cdef extern from "falcon_core/physics/device_structures/Connections_c_api.h":
    ctypedef void* ConnectionsHandle

    ConnectionsHandle Connections_create_empty()
    ConnectionsHandle Connections_create(void* list_connection_handle)
    void Connections_destroy(ConnectionsHandle handle)

    int Connections_is_gates(ConnectionsHandle handle)
    int Connections_is_ohmics(ConnectionsHandle handle)
    int Connections_is_dot_gates(ConnectionsHandle handle)
    int Connections_is_plunger_gates(ConnectionsHandle handle)
    int Connections_is_barrier_gates(ConnectionsHandle handle)
    int Connections_is_reservoir_gates(ConnectionsHandle handle)
    int Connections_is_screening_gates(ConnectionsHandle handle)

    ConnectionsHandle Connections_intersection(ConnectionsHandle handle, ConnectionsHandle other)
    void Connections_push_back(ConnectionsHandle handle, ConnectionHandle value)
    size_t Connections_size(ConnectionsHandle handle)
    int    Connections_empty(ConnectionsHandle handle)
    void   Connections_erase_at(ConnectionsHandle handle, size_t idx)
    void   Connections_clear(ConnectionsHandle handle)
    ConnectionHandle Connections_at(ConnectionsHandle handle, size_t idx)
    ListConnectionHandle Connections_items(ConnectionsHandle handle)
    int    Connections_contains(ConnectionsHandle handle, ConnectionHandle value)
    size_t Connections_index(ConnectionsHandle handle, ConnectionHandle value)
    int    Connections_equal(ConnectionsHandle a, ConnectionsHandle b)
    int    Connections_not_equal(ConnectionsHandle a, ConnectionsHandle b)

    StringHandle Connections_to_json_string(ConnectionsHandle handle)
    ConnectionsHandle Connections_from_json_string(StringHandle json)
