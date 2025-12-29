cimport _c_api

cdef class MapGnameGroup:
    cdef _c_api.MapGnameGroupHandle handle
    cdef bint owned

cdef MapGnameGroup _map_gname_group_from_capi(_c_api.MapGnameGroupHandle h, bint owned=*)