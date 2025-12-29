cimport _c_api

cdef class ListPairInterpretationContextString:
    cdef _c_api.ListPairInterpretationContextStringHandle handle
    cdef bint owned

cdef ListPairInterpretationContextString _list_pair_interpretation_context_string_from_capi(_c_api.ListPairInterpretationContextStringHandle h, bint owned=*)