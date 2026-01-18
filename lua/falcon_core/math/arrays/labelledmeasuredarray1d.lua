-- labelledmeasuredarray1d.lua
-- Auto-generated wrapper for LabelledMeasuredArray1D
-- Generated from LabelledMeasuredArray1D_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local LabelledMeasuredArray1D = {}

-- Constructors


-- Methods

function LabelledMeasuredArray1D.is_1D(handle)
    return cdef.lib.LabelledMeasuredArray1D_is_1D(handle)
end

function LabelledMeasuredArray1D.get_start(handle)
    return cdef.lib.LabelledMeasuredArray1D_get_start(handle)
end

function LabelledMeasuredArray1D.get_end(handle)
    return cdef.lib.LabelledMeasuredArray1D_get_end(handle)
end

function LabelledMeasuredArray1D.get_mean(handle)
    return cdef.lib.LabelledMeasuredArray1D_get_mean(handle)
end

function LabelledMeasuredArray1D.get_std(handle)
    return cdef.lib.LabelledMeasuredArray1D_get_std(handle)
end


return LabelledMeasuredArray1D
