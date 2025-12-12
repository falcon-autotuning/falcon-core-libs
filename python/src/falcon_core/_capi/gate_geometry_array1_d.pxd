cimport _c_api

cdef class GateGeometryArray1D:
    cdef _c_api.GateGeometryArray1DHandle handle
    cdef bint owned

cdef GateGeometryArray1D _gate_geometry_array1_d_from_capi(_c_api.GateGeometryArray1DHandle h)