cimport _c_api

cdef class Channels:
    cdef _c_api.ChannelsHandle handle
    cdef bint owned

cdef Channels _channels_from_capi(_c_api.ChannelsHandle h, bint owned=*)