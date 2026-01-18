-- labelledarrayslabelledmeasuredarray1d.lua
-- Auto-generated wrapper for LabelledArraysLabelledMeasuredArray1D
-- Generated from LabelledArraysLabelledMeasuredArray1D_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local LabelledArraysLabelledMeasuredArray1D = {}

-- Constructors

function LabelledArraysLabelledMeasuredArray1D.from_json_string(json)
    return cdef.lib.LabelledArraysLabelledMeasuredArray1D_from_json_string(json)
end


-- Methods

function LabelledArraysLabelledMeasuredArray1D.copy(handle)
    return cdef.lib.LabelledArraysLabelledMeasuredArray1D_copy(handle)
end

function LabelledArraysLabelledMeasuredArray1D.to_json_string(handle)
    return cdef.lib.LabelledArraysLabelledMeasuredArray1D_to_json_string(handle)
end

function LabelledArraysLabelledMeasuredArray1D.from_json_string(handle)
    return cdef.lib.LabelledArraysLabelledMeasuredArray1D_from_json_string(handle)
end


return LabelledArraysLabelledMeasuredArray1D
