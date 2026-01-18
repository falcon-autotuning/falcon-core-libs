-- control_array.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local ControlArray = {}

song.register("ControlArray", {
    __add = lib.ControlArray_plus_control_array,
    __sub = lib.ControlArray_minus_control_array,
    __mul = lib.ControlArray_times_double, -- Usually multiplied by scalar
    __div = lib.ControlArray_divides_double,
    __unm = lib.ControlArray_negation,
    methods = {
        size = function(t) return tonumber(lib.ControlArray_size(t)) end,
        dimension = lib.ControlArray_dimension,
        add = lib.ControlArray_plus_control_array,
        subtract = lib.ControlArray_minus_control_array,
        multiply = lib.ControlArray_times_double,
        divide = lib.ControlArray_divides_double,
        min = lib.ControlArray_min,
        max = lib.ControlArray_max,
        abs = lib.ControlArray_abs,
        sum = lib.ControlArray_sum,
    }
}, ControlArray)

return ControlArray
