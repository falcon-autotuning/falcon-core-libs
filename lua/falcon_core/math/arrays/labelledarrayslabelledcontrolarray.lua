-- labelledarrayslabelledcontrolarray.lua
-- Auto-generated wrapper for LabelledArraysLabelledControlArray
-- Generated from LabelledArraysLabelledControlArray_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local LabelledArraysLabelledControlArray = {}

-- Constructors

function LabelledArraysLabelledControlArray.from_json_string(json)
    return cdef.lib.LabelledArraysLabelledControlArray_from_json_string(json)
end


-- Methods

function LabelledArraysLabelledControlArray.copy(handle)
    return cdef.lib.LabelledArraysLabelledControlArray_copy(handle)
end

function LabelledArraysLabelledControlArray.to_json_string(handle)
    return cdef.lib.LabelledArraysLabelledControlArray_to_json_string(handle)
end

function LabelledArraysLabelledControlArray.from_json_string(handle)
    return cdef.lib.LabelledArraysLabelledControlArray_from_json_string(handle)
end


return LabelledArraysLabelledControlArray
