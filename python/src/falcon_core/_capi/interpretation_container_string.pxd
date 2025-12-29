cimport _c_api

cdef class InterpretationContainerString:
    cdef _c_api.InterpretationContainerStringHandle handle
    cdef bint owned

cdef InterpretationContainerString _interpretation_container_string_from_capi(_c_api.InterpretationContainerStringHandle h, bint owned=*)