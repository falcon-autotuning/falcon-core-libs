cimport _c_api

cdef class MapInterpretationContextQuantity:
    cdef _c_api.MapInterpretationContextQuantityHandle handle
    cdef bint owned

cdef MapInterpretationContextQuantity _map_interpretation_context_quantity_from_capi(_c_api.MapInterpretationContextQuantityHandle h, bint owned=*)