-- hdf5data.lua
-- Auto-generated wrapper for HDF5Data
-- Generated from HDF5Data_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local HDF5Data = {}

-- Constructors

function HDF5Data.from_json_string(json)
    return cdef.lib.HDF5Data_from_json_string(json)
end

function HDF5Data.from_file(path)
    return cdef.lib.HDF5Data_create_from_file(path)
end


-- Methods

function HDF5Data.copy(handle)
    return cdef.lib.HDF5Data_copy(handle)
end

function HDF5Data.equal(handle, other)
    return cdef.lib.HDF5Data_equal(handle, other)
end

function HDF5Data.not_equal(handle, other)
    return cdef.lib.HDF5Data_not_equal(handle, other)
end

function HDF5Data.to_json_string(handle)
    return cdef.lib.HDF5Data_to_json_string(handle)
end

function HDF5Data.from_json_string(handle)
    return cdef.lib.HDF5Data_from_json_string(handle)
end


return HDF5Data
