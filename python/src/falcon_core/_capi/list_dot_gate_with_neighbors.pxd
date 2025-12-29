cimport _c_api

cdef class ListDotGateWithNeighbors:
    cdef _c_api.ListDotGateWithNeighborsHandle handle
    cdef bint owned

cdef ListDotGateWithNeighbors _list_dot_gate_with_neighbors_from_capi(_c_api.ListDotGateWithNeighborsHandle h, bint owned=*)