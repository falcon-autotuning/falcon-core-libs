cimport _c_api

cdef class DiscreteSpace:
    cdef _c_api.DiscreteSpaceHandle handle
    cdef bint owned

cdef DiscreteSpace _discrete_space_from_capi(_c_api.DiscreteSpaceHandle h)