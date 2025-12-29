cimport _c_api

cdef class ListFloat:
    cdef _c_api.ListFloatHandle handle
    cdef bint owned

cdef ListFloat _list_float_from_capi(_c_api.ListFloatHandle h, bint owned=*)