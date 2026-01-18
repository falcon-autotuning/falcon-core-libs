-- arrays/labelled_control_array.lua
-- Wrapper for LabelledControlArray (control data with acquisition context)

local cdef = require("falcon_core.ffi.cdef")

local LabelledControlArray = {}

-- Create from FArray and label
function LabelledControlArray.from_farray(farray, label)
    return cdef.lib.LabelledControlArray_from_farray(farray, label)
end

-- Get data
function LabelledControlArray.as_1d(arr)
    return cdef.lib.LabelledControlArray_as_1D(arr)
end

-- Get label
function LabelledControlArray.label(arr)
    return cdef.lib.LabelledControlArray_label(arr)
end

-- Arithmetic
function LabelledControlArray.add(arr, other)
    return cdef.lib.LabelledControlArray_plus_farray(arr, other)
end

-- Gradient
function LabelledControlArray.gradient(arr, axis)
    return cdef.lib.LabelledControlArray_gradient(arr, axis)
end

return LabelledControlArray
