-- controlarray1d.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local ControlArray1D = {}

song.register("ControlArray1D", {
    __add = lib.ControlArray1D_plus_control_array,
    __sub = lib.ControlArray1D_minus_control_array,
    __mul = lib.ControlArray1D_times_double,
    __div = lib.ControlArray1D_divides_double,
    __unm = lib.ControlArray1D_negation,
    methods = {
        size = function(t) return tonumber(lib.ControlArray1D_size(t)) end,
        dimension = lib.ControlArray1D_dimension,
        add = lib.ControlArray1D_plus_control_array,
        subtract = lib.ControlArray1D_minus_control_array,
        multiply = lib.ControlArray1D_times_double,
        divide = lib.ControlArray1D_divides_double,
        min = lib.ControlArray1D_min,
        max = lib.ControlArray1D_max,
        abs = lib.ControlArray1D_abs,
        sum = lib.ControlArray1D_sum,
        as_1D = lib.ControlArray1D_as_1D,
    }
}, ControlArray1D)

return ControlArray1D
