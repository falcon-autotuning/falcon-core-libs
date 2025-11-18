from . cimport c_api

cdef PairIntInt _pairintint_from_capi(c_api.PairIntIntHandle h)

cdef class PairIntInt:
    cdef c_api.PairIntIntHandle handle
    cdef bint owned
    cdef PairIntInt from_capi(PairIntInt cls, c_api.PairIntIntHandle h)
