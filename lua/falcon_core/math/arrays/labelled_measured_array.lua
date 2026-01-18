-- labelled_measured_array.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local LabelledMeasuredArray = {}

song.register("LabelledMeasuredArray", {
    __add = lib.LabelledMeasuredArray_plus_measured_array,
    __sub = lib.LabelledMeasuredArray_minus_measured_array,
    __mul = lib.LabelledMeasuredArray_times_measured_array,
    __div = lib.LabelledMeasuredArray_divides_measured_array,
    __unm = lib.LabelledMeasuredArray_negation,
    methods = {
        size = function(t) return tonumber(lib.LabelledMeasuredArray_size(t)) end,
        dimension = lib.LabelledMeasuredArray_dimension,
        label = lib.LabelledMeasuredArray_label,
        connection = lib.LabelledMeasuredArray_connection,
        units = lib.LabelledMeasuredArray_units,
        instrument_type = lib.LabelledMeasuredArray_instrument_type,
        add = lib.LabelledMeasuredArray_plus_measured_array,
        subtract = lib.LabelledMeasuredArray_minus_measured_array,
        multiply = lib.LabelledMeasuredArray_times_measured_array,
        divide = lib.LabelledMeasuredArray_divides_measured_array,
    }
}, LabelledMeasuredArray)

return LabelledMeasuredArray
