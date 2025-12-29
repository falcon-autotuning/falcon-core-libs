cimport _c_api

cdef class InterpretationContext:
    cdef _c_api.InterpretationContextHandle handle
    cdef bint owned

cdef InterpretationContext _interpretation_context_from_capi(_c_api.InterpretationContextHandle h, bint owned=*)