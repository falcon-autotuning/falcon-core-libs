-- hdf5data.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local HDF5Data = {}

song.register("HDF5Data", {
    methods = {
        save = lib.HDF5Data_to_file,
        to_file = lib.HDF5Data_to_file,
        to_communications = lib.HDF5Data_to_communications,
        shape = lib.HDF5Data_shape,
        metadata = lib.HDF5Data_metadata,
        measurement_title = lib.HDF5Data_measurement_title,
    }
}, HDF5Data)

return HDF5Data
