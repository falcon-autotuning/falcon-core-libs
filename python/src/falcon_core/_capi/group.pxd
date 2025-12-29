cimport _c_api

cdef class Group:
    cdef _c_api.GroupHandle handle
    cdef bint owned

cdef Group _group_from_capi(_c_api.GroupHandle h, bint owned=*)