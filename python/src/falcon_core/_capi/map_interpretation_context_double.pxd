cimport _c_api

cdef class MapInterpretationContextDouble:
    cdef _c_api.MapInterpretationContextDoubleHandle handle
    cdef bint owned

cdef MapInterpretationContextDouble _map_interpretation_context_double_from_capi(_c_api.MapInterpretationContextDoubleHandle h, bint owned=*)