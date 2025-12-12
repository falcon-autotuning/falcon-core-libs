cimport _c_api

cdef class LeftReservoirWithImplantedOhmic:
    cdef _c_api.LeftReservoirWithImplantedOhmicHandle handle
    cdef bint owned

cdef LeftReservoirWithImplantedOhmic _left_reservoir_with_implanted_ohmic_from_capi(_c_api.LeftReservoirWithImplantedOhmicHandle h)