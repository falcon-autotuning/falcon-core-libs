cimport _c_api

cdef class UnitSpace:
    cdef _c_api.UnitSpaceHandle handle
    cdef bint owned

cdef UnitSpace _unit_space_from_capi(_c_api.UnitSpaceHandle h, bint owned=*)