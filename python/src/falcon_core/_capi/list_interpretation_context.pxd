cimport _c_api

cdef class ListInterpretationContext:
    cdef _c_api.ListInterpretationContextHandle handle
    cdef bint owned

cdef ListInterpretationContext _list_interpretation_context_from_capi(_c_api.ListInterpretationContextHandle h, bint owned=*)