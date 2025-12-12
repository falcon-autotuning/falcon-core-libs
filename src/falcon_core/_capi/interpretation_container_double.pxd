cimport _c_api

cdef class InterpretationContainerDouble:
    cdef _c_api.InterpretationContainerDoubleHandle handle
    cdef bint owned

cdef InterpretationContainerDouble _interpretation_container_double_from_capi(_c_api.InterpretationContainerDoubleHandle h)