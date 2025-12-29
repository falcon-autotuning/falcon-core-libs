cimport _c_api

cdef class PortTransform:
    cdef _c_api.PortTransformHandle handle
    cdef bint owned

cdef PortTransform _port_transform_from_capi(_c_api.PortTransformHandle h, bint owned=*)