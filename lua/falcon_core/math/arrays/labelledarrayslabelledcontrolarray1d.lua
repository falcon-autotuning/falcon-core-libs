-- labelledarrayslabelledcontrolarray1d.lua
-- Auto-generated wrapper for LabelledArraysLabelledControlArray1D
-- Generated from LabelledArraysLabelledControlArray1D_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local LabelledArraysLabelledControlArray1D = {}

-- Constructors

function LabelledArraysLabelledControlArray1D.from_json_string(json)
    return cdef.lib.LabelledArraysLabelledControlArray1D_from_json_string(json)
end


-- Methods

function LabelledArraysLabelledControlArray1D.copy(handle)
    return cdef.lib.LabelledArraysLabelledControlArray1D_copy(handle)
end

function LabelledArraysLabelledControlArray1D.to_json_string(handle)
    return cdef.lib.LabelledArraysLabelledControlArray1D_to_json_string(handle)
end

function LabelledArraysLabelledControlArray1D.from_json_string(handle)
    return cdef.lib.LabelledArraysLabelledControlArray1D_from_json_string(handle)
end


return LabelledArraysLabelledControlArray1D
