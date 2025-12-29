cimport _c_api

cdef class AnalyticFunction:
    cdef _c_api.AnalyticFunctionHandle handle
    cdef bint owned

cdef AnalyticFunction _analytic_function_from_capi(_c_api.AnalyticFunctionHandle h, bint owned=*)