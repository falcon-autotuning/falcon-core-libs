-- labelledmeasuredarray1d.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local LabelledMeasuredArray1D = {}

song.register("LabelledMeasuredArray1D", {
    __add = lib.LabelledMeasuredArray1D_plus_measured_array,
    __sub = lib.LabelledMeasuredArray1D_minus_measured_array,
    __mul = lib.LabelledMeasuredArray1D_times_measured_array,
    __div = lib.LabelledMeasuredArray1D_divides_measured_array,
    __unm = lib.LabelledMeasuredArray1D_negation,
    methods = {
        size = function(t) return tonumber(lib.LabelledMeasuredArray1D_size(t)) end,
        label = lib.LabelledMeasuredArray1D_label,
        connection = lib.LabelledMeasuredArray1D_connection,
        units = lib.LabelledMeasuredArray1D_units,
        instrument_type = lib.LabelledMeasuredArray1D_instrument_type,
        add = lib.LabelledMeasuredArray1D_plus_measured_array,
        subtract = lib.LabelledMeasuredArray1D_minus_measured_array,
        multiply = lib.LabelledMeasuredArray1D_times_measured_array,
        divide = lib.LabelledMeasuredArray1D_divides_measured_array,
        as_1D = lib.LabelledMeasuredArray1D_as_1D,
    }
}, LabelledMeasuredArray1D)

return LabelledMeasuredArray1D
