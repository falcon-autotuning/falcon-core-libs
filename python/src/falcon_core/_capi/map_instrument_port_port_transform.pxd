cimport _c_api

cdef class MapInstrumentPortPortTransform:
    cdef _c_api.MapInstrumentPortPortTransformHandle handle
    cdef bint owned

cdef MapInstrumentPortPortTransform _map_instrument_port_port_transform_from_capi(_c_api.MapInstrumentPortPortTransformHandle h, bint owned=*)