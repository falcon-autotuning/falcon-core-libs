cimport _c_api

cdef class PairInterpretationContextString:
    cdef _c_api.PairInterpretationContextStringHandle handle
    cdef bint owned

cdef PairInterpretationContextString _pair_interpretation_context_string_from_capi(_c_api.PairInterpretationContextStringHandle h, bint owned=*)