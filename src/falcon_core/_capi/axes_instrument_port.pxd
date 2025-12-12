cimport _c_api

cdef class AxesInstrumentPort:
    cdef _c_api.AxesInstrumentPortHandle handle
    cdef bint owned

cdef AxesInstrumentPort _axes_instrument_port_from_capi(_c_api.AxesInstrumentPortHandle h)