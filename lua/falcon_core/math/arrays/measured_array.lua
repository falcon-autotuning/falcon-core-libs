-- arrays/measured_array.lua
-- Wrapper for MeasuredArray (n-dimensional measured data)

local cdef = require("falcon_core.ffi.cdef")

local MeasuredArray = {}

-- Create from FArray
function MeasuredArray.from_farray(farray)
    return cdef.lib.MeasuredArray_from_farray(farray)
end

-- Convert to 1D (if applicable)
function MeasuredArray.as_1d(arr)
    return cdef.lib.MeasuredArray_as_1D(arr)
end

-- Arithmetic operations
function MeasuredArray.add(arr, other)
    return cdef.lib.MeasuredArray_plus_farray(arr, other)
end

function MeasuredArray.subtract(arr, other)
    return cdef.lib.MeasuredArray_minus_farray(arr, other)
end

function MeasuredArray.multiply(arr, other)
    return cdef.lib.MeasuredArray_times_farray(arr, other)
end

function MeasuredArray.divide(arr, other)
    return cdef.lib.MeasuredArray_divides_farray(arr, other)
end

-- Min/max operations
function MeasuredArray.min(arr, other)
    return cdef.lib.MeasuredArray_min_farray(arr, other)
end

function MeasuredArray.max(arr, other)
    return cdef.lib.MeasuredArray_max_farray(arr, other)
end

return MeasuredArray
