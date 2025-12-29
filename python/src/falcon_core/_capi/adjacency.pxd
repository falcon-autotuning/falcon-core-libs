cimport _c_api

cdef class Adjacency:
    cdef _c_api.AdjacencyHandle handle
    cdef bint owned

cdef Adjacency _adjacency_from_capi(_c_api.AdjacencyHandle h, bint owned=*)