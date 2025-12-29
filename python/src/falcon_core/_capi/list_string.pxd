cimport _c_api

cdef class ListString:
    cdef _c_api.ListStringHandle handle
    cdef bint owned

cdef ListString _list_string_from_capi(_c_api.ListStringHandle h, bint owned=*)