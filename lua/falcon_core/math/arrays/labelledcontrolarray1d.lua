-- labelledcontrolarray1d.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local LabelledControlArray1D = {}

song.register("LabelledControlArray1D", {
    __add = lib.LabelledControlArray1D_plus_control_array,
    __sub = lib.LabelledControlArray1D_minus_control_array,
    __mul = lib.LabelledControlArray1D_times_double,
    __div = lib.LabelledControlArray1D_divides_double,
    __unm = lib.LabelledControlArray1D_negation,
    methods = {
        size = function(t) return tonumber(lib.LabelledControlArray1D_size(t)) end,
        label = lib.LabelledControlArray1D_label,
        connection = lib.LabelledControlArray1D_connection,
        units = lib.LabelledControlArray1D_units,
        instrument_type = lib.LabelledControlArray1D_instrument_type,
        add = lib.LabelledControlArray1D_plus_control_array,
        subtract = lib.LabelledControlArray1D_minus_control_array,
        multiply = lib.LabelledControlArray1D_times_double,
        divide = lib.LabelledControlArray1D_divides_double,
        as_1D = lib.LabelledControlArray1D_as_1D,
    }
}, LabelledControlArray1D)

return LabelledControlArray1D
