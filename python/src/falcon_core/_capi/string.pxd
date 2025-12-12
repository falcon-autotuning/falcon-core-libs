cimport _c_api

cdef class String:
    cdef _c_api.StringHandle handle
    cdef bint owned

cdef String _string_from_capi(_c_api.StringHandle h)