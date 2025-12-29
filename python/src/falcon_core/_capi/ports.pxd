cimport _c_api

cdef class Ports:
    cdef _c_api.PortsHandle handle
    cdef bint owned

cdef Ports _ports_from_capi(_c_api.PortsHandle h, bint owned=*)