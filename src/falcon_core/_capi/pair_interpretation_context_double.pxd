cimport _c_api

cdef class PairInterpretationContextDouble:
    cdef _c_api.PairInterpretationContextDoubleHandle handle
    cdef bint owned

cdef PairInterpretationContextDouble _pair_interpretation_context_double_from_capi(_c_api.PairInterpretationContextDoubleHandle h)