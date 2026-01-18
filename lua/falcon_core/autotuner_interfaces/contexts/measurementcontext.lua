-- measurementcontext.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local MeasurementContext = {}

song.register("MeasurementContext", {
    methods = {
        connection = lib.MeasurementContext_connection,
        instrument_type = lib.MeasurementContext_instrument_type,
    }
}, MeasurementContext)

return MeasurementContext
