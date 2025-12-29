cimport _c_api

cdef class MapFloatFloat:
    cdef _c_api.MapFloatFloatHandle handle
    cdef bint owned

cdef MapFloatFloat _map_float_float_from_capi(_c_api.MapFloatFloatHandle h, bint owned=*)