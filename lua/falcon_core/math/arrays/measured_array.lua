-- measured_array.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local MeasuredArray = {}

song.register("MeasuredArray", {
    __add = lib.MeasuredArray_plus_measured_array,
    __sub = lib.MeasuredArray_minus_measured_array,
    __mul = lib.MeasuredArray_times_measured_array,
    __div = lib.MeasuredArray_divides_measured_array,
    __unm = lib.MeasuredArray_negation,
    methods = {
        size = function(t) return tonumber(lib.MeasuredArray_size(t)) end,
        dimension = lib.MeasuredArray_dimension,
        add = lib.MeasuredArray_plus_measured_array,
        subtract = lib.MeasuredArray_minus_measured_array,
        multiply = lib.MeasuredArray_times_measured_array,
        divide = lib.MeasuredArray_divides_measured_array,
        min = lib.MeasuredArray_min,
        max = lib.MeasuredArray_max,
        abs = lib.MeasuredArray_abs,
        sum = lib.MeasuredArray_sum,
    }
}, MeasuredArray)

return MeasuredArray
