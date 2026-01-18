-- arrays/control_array.lua
-- Wrapper for ControlArray (n-dimensional control data)

local cdef = require("falcon_core.ffi.cdef")

local ControlArray = {}

-- Create from FArray
function ControlArray.from_farray(farray)
    return cdef.lib.ControlArray_from_farray(farray)
end

-- Convert to 1D
function ControlArray.as_1d(arr)
    return cdef.lib.ControlArray_as_1D(arr)
end

-- Arithmetic operations
function ControlArray.add(arr, other)
    return cdef.lib.ControlArray_plus_farray(arr, other)
end

function ControlArray.subtract(arr, other)
    return cdef.lib.ControlArray_minus_farray(arr, other)
end

-- Min/max operations
function ControlArray.min(arr, other)
    return cdef.lib.ControlArray_min_farray(arr, other)
end

function ControlArray.max(arr, other)
    return cdef.lib.ControlArray_max_farray(arr, other)
end

-- Gradient operations
function ControlArray.gradient(arr, axis)
    return cdef.lib.ControlArray_gradient(arr, axis)
end

return ControlArray
