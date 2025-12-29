cimport _c_api

cdef class DotGateWithNeighbors:
    cdef _c_api.DotGateWithNeighborsHandle handle
    cdef bint owned

cdef DotGateWithNeighbors _dot_gate_with_neighbors_from_capi(_c_api.DotGateWithNeighborsHandle h, bint owned=*)