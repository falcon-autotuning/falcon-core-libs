cimport _c_api

cdef class PortTransforms:
    cdef _c_api.PortTransformsHandle handle
    cdef bint owned

cdef PortTransforms _port_transforms_from_capi(_c_api.PortTransformsHandle h, bint owned=*)