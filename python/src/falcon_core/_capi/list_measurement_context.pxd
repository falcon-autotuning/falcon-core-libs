cimport _c_api

cdef class ListMeasurementContext:
    cdef _c_api.ListMeasurementContextHandle handle
    cdef bint owned

cdef ListMeasurementContext _list_measurement_context_from_capi(_c_api.ListMeasurementContextHandle h, bint owned=*)