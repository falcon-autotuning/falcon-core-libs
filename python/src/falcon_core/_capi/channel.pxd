cimport _c_api

cdef class Channel:
    cdef _c_api.ChannelHandle handle
    cdef bint owned

cdef Channel _channel_from_capi(_c_api.ChannelHandle h, bint owned=*)