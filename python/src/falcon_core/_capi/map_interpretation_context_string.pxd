cimport _c_api

cdef class MapInterpretationContextString:
    cdef _c_api.MapInterpretationContextStringHandle handle
    cdef bint owned

cdef MapInterpretationContextString _map_interpretation_context_string_from_capi(_c_api.MapInterpretationContextStringHandle h, bint owned=*)