cimport _c_api

cdef class PairGnameGroup:
    cdef _c_api.PairGnameGroupHandle handle
    cdef bint owned

cdef PairGnameGroup _pair_gname_group_from_capi(_c_api.PairGnameGroupHandle h)