cimport _c_api

cdef class HDF5Data:
    cdef _c_api.HDF5DataHandle handle
    cdef bint owned

cdef HDF5Data _hdf5_data_from_capi(_c_api.HDF5DataHandle h)