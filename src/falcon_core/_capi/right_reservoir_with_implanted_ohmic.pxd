cimport _c_api

cdef class RightReservoirWithImplantedOhmic:
    cdef _c_api.RightReservoirWithImplantedOhmicHandle handle
    cdef bint owned

cdef RightReservoirWithImplantedOhmic _right_reservoir_with_implanted_ohmic_from_capi(_c_api.RightReservoirWithImplantedOhmicHandle h)