-- arrays/labelled_measured_array.lua
-- Wrapper for LabelledMeasuredArray (measured data with acquisition context)

local cdef = require("falcon_core.ffi.cdef")

local LabelledMeasuredArray = {}

-- Create from FArray and label
function LabelledMeasuredArray.from_farray(farray, label)
    return cdef.lib.LabelledMeasuredArray_from_farray(farray, label)
end

-- Get data as 1D
function LabelledMeasuredArray.as_1d(arr)
    return cdef.lib.LabelledMeasuredArray_as_1D(arr)
end

-- Get label
function LabelledMeasuredArray.label(arr)
    return cdef.lib.LabelledMeasuredArray_label(arr)
end

-- Arithmetic with other arrays
function LabelledMeasuredArray.add(arr, other)
    return cdef.lib.LabelledMeasuredArray_plus_farray(arr, other)
end

function LabelledMeasuredArray.multiply(arr, other)
    return cdef.lib.LabelledMeasuredArray_times_farray(arr, other)
end

return LabelledMeasuredArray
