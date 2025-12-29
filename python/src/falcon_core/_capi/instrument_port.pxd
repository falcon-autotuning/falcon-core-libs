cimport _c_api

cdef class InstrumentPort:
    cdef _c_api.InstrumentPortHandle handle
    cdef bint owned

cdef InstrumentPort _instrument_port_from_capi(_c_api.InstrumentPortHandle h, bint owned=*)