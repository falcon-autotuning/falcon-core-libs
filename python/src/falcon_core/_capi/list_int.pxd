from . cimport c_api

cdef ListInt _listint_from_capi(c_api.ListIntHandle h)

cdef class ListInt:
    cdef c_api.ListIntHandle handle
    cdef bint owned
    cdef ListInt from_capi(ListInt cls, c_api.ListIntHandle h)
