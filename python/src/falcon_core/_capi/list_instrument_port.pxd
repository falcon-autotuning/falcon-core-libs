cimport _c_api

cdef class ListInstrumentPort:
    cdef _c_api.ListInstrumentPortHandle handle
    cdef bint owned

cdef ListInstrumentPort _list_instrument_port_from_capi(_c_api.ListInstrumentPortHandle h, bint owned=*)