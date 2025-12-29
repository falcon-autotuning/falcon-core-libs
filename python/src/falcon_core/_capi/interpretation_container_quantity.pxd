cimport _c_api

cdef class InterpretationContainerQuantity:
    cdef _c_api.InterpretationContainerQuantityHandle handle
    cdef bint owned

cdef InterpretationContainerQuantity _interpretation_container_quantity_from_capi(_c_api.InterpretationContainerQuantityHandle h, bint owned=*)