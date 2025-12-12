cimport _c_api

cdef class Waveform:
    cdef _c_api.WaveformHandle handle
    cdef bint owned

cdef Waveform _waveform_from_capi(_c_api.WaveformHandle h)