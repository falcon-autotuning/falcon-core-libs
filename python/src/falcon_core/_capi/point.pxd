cimport _c_api

cdef class Point:
    cdef _c_api.PointHandle handle
    cdef bint owned

cdef Point _point_from_capi(_c_api.PointHandle h, bint owned=*)