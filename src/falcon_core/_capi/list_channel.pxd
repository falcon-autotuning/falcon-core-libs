cimport _c_api

cdef class ListChannel:
    cdef _c_api.ListChannelHandle handle
    cdef bint owned

cdef ListChannel _list_channel_from_capi(_c_api.ListChannelHandle h)