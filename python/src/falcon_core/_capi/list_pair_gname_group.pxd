cimport _c_api

cdef class ListPairGnameGroup:
    cdef _c_api.ListPairGnameGroupHandle handle
    cdef bint owned

cdef ListPairGnameGroup _list_pair_gname_group_from_capi(_c_api.ListPairGnameGroupHandle h, bint owned=*)