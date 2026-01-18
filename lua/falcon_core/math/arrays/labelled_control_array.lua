-- labelled_control_array.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local LabelledControlArray = {}

song.register("LabelledControlArray", {
    __add = lib.LabelledControlArray_plus_control_array,
    __sub = lib.LabelledControlArray_minus_control_array,
    __mul = lib.LabelledControlArray_times_double,
    __div = lib.LabelledControlArray_divides_double,
    __unm = lib.LabelledControlArray_negation,
    methods = {
        size = function(t) return tonumber(lib.LabelledControlArray_size(t)) end,
        dimension = lib.LabelledControlArray_dimension,
        label = lib.LabelledControlArray_label,
        connection = lib.LabelledControlArray_connection,
        units = lib.LabelledControlArray_units,
        instrument_type = lib.LabelledControlArray_instrument_type,
        add = lib.LabelledControlArray_plus_control_array,
        subtract = lib.LabelledControlArray_minus_control_array,
        multiply = lib.LabelledControlArray_times_double,
        divide = lib.LabelledControlArray_divides_double,
    }
}, LabelledControlArray)

return LabelledControlArray
