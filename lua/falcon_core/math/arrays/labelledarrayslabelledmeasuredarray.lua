-- labelledarrayslabelledmeasuredarray.lua
-- Auto-generated wrapper for LabelledArraysLabelledMeasuredArray
-- Generated from LabelledArraysLabelledMeasuredArray_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local LabelledArraysLabelledMeasuredArray = {}

-- Constructors

function LabelledArraysLabelledMeasuredArray.from_json_string(json)
    return cdef.lib.LabelledArraysLabelledMeasuredArray_from_json_string(json)
end


-- Methods

function LabelledArraysLabelledMeasuredArray.copy(handle)
    return cdef.lib.LabelledArraysLabelledMeasuredArray_copy(handle)
end

function LabelledArraysLabelledMeasuredArray.to_json_string(handle)
    return cdef.lib.LabelledArraysLabelledMeasuredArray_to_json_string(handle)
end

function LabelledArraysLabelledMeasuredArray.from_json_string(handle)
    return cdef.lib.LabelledArraysLabelledMeasuredArray_from_json_string(handle)
end


return LabelledArraysLabelledMeasuredArray
