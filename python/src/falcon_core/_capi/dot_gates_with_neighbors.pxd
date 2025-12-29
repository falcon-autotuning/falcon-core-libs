cimport _c_api

cdef class DotGatesWithNeighbors:
    cdef _c_api.DotGatesWithNeighborsHandle handle
    cdef bint owned

cdef DotGatesWithNeighbors _dot_gates_with_neighbors_from_capi(_c_api.DotGatesWithNeighborsHandle h, bint owned=*)