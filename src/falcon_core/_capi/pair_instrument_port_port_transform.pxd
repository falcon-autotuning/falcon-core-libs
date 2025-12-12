cimport _c_api

cdef class PairInstrumentPortPortTransform:
    cdef _c_api.PairInstrumentPortPortTransformHandle handle
    cdef bint owned

cdef PairInstrumentPortPortTransform _pair_instrument_port_port_transform_from_capi(_c_api.PairInstrumentPortPortTransformHandle h)