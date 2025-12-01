cimport _c_api

cdef class Gname:
    cdef _c_api.GnameHandle handle
    cdef bint owned

cdef Gname _gname_from_capi(_c_api.GnameHandle h)