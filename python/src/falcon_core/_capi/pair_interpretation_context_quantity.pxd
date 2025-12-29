cimport _c_api

cdef class PairInterpretationContextQuantity:
    cdef _c_api.PairInterpretationContextQuantityHandle handle
    cdef bint owned

cdef PairInterpretationContextQuantity _pair_interpretation_context_quantity_from_capi(_c_api.PairInterpretationContextQuantityHandle h, bint owned=*)