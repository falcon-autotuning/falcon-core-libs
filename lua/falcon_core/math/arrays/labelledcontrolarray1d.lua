-- labelledcontrolarray1d.lua
-- Auto-generated wrapper for LabelledControlArray1D
-- Generated from LabelledControlArray1D_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local LabelledControlArray1D = {}

-- Constructors


-- Methods

function LabelledControlArray1D.is_1D(handle)
    return cdef.lib.LabelledControlArray1D_is_1D(handle)
end

function LabelledControlArray1D.get_start(handle)
    return cdef.lib.LabelledControlArray1D_get_start(handle)
end

function LabelledControlArray1D.get_end(handle)
    return cdef.lib.LabelledControlArray1D_get_end(handle)
end

function LabelledControlArray1D.is_decreasing(handle)
    return cdef.lib.LabelledControlArray1D_is_decreasing(handle)
end

function LabelledControlArray1D.is_increasing(handle)
    return cdef.lib.LabelledControlArray1D_is_increasing(handle)
end


return LabelledControlArray1D
