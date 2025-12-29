cimport _c_api

cdef class ListImpedance:
    cdef _c_api.ListImpedanceHandle handle
    cdef bint owned

cdef ListImpedance _list_impedance_from_capi(_c_api.ListImpedanceHandle h, bint owned=*)