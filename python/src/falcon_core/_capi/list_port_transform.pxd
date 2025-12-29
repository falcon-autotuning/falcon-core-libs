cimport _c_api

cdef class ListPortTransform:
    cdef _c_api.ListPortTransformHandle handle
    cdef bint owned

cdef ListPortTransform _list_port_transform_from_capi(_c_api.ListPortTransformHandle h, bint owned=*)