cimport _c_api

cdef class Vector:
    cdef _c_api.VectorHandle handle
    cdef bint owned

cdef Vector _vector_from_capi(_c_api.VectorHandle h)