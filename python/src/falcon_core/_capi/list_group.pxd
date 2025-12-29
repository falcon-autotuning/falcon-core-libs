cimport _c_api

cdef class ListGroup:
    cdef _c_api.ListGroupHandle handle
    cdef bint owned

cdef ListGroup _list_group_from_capi(_c_api.ListGroupHandle h, bint owned=*)