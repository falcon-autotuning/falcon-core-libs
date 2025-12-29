cimport _c_api

cdef class ListWaveform:
    cdef _c_api.ListWaveformHandle handle
    cdef bint owned

cdef ListWaveform _list_waveform_from_capi(_c_api.ListWaveformHandle h, bint owned=*)