-- measuredarray1d.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local MeasuredArray1D = {}

song.register("MeasuredArray1D", {
    __add = lib.MeasuredArray1D_plus_measured_array,
    __sub = lib.MeasuredArray1D_minus_measured_array,
    __mul = lib.MeasuredArray1D_times_measured_array,
    __div = lib.MeasuredArray1D_divides_measured_array,
    __unm = lib.MeasuredArray1D_negation,
    methods = {
        size = function(t) return tonumber(lib.MeasuredArray1D_size(t)) end,
        dimension = lib.MeasuredArray1D_dimension,
        add = lib.MeasuredArray1D_plus_measured_array,
        subtract = lib.MeasuredArray1D_minus_measured_array,
        multiply = lib.MeasuredArray1D_times_measured_array,
        divide = lib.MeasuredArray1D_divides_measured_array,
        min = lib.MeasuredArray1D_min,
        max = lib.MeasuredArray1D_max,
        abs = lib.MeasuredArray1D_abs,
        sum = lib.MeasuredArray1D_sum,
        as_1D = lib.MeasuredArray1D_as_1D,
    }
}, MeasuredArray1D)

return MeasuredArray1D
