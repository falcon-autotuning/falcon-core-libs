-- measuredarray1d.lua
-- Auto-generated wrapper for MeasuredArray1D
-- Generated from MeasuredArray1D_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local MeasuredArray1D = {}

-- Constructors

function MeasuredArray1D.from_json_string(json)
    return cdef.lib.MeasuredArray1D_from_json_string(json)
end

function MeasuredArray1D.from_farray(farray)
    return cdef.lib.MeasuredArray1D_from_farray(farray)
end


-- Methods

function MeasuredArray1D.copy(handle)
    return cdef.lib.MeasuredArray1D_copy(handle)
end

function MeasuredArray1D.to_json_string(handle)
    return cdef.lib.MeasuredArray1D_to_json_string(handle)
end

function MeasuredArray1D.from_json_string(handle)
    return cdef.lib.MeasuredArray1D_from_json_string(handle)
end

function MeasuredArray1D.from_farray(handle)
    return cdef.lib.MeasuredArray1D_from_farray(handle)
end

function MeasuredArray1D.is_1D(handle)
    return cdef.lib.MeasuredArray1D_is_1D(handle)
end


return MeasuredArray1D
