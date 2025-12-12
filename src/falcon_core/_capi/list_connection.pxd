cimport _c_api

cdef class ListConnection:
    cdef _c_api.ListConnectionHandle handle
    cdef bint owned

cdef ListConnection _list_connection_from_capi(_c_api.ListConnectionHandle h)