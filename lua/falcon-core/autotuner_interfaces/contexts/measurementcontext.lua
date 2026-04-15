-- measurementcontext.lua
local cdef = require("falcon-core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon-core.utils.song")
local MeasurementContext = {}

song.register("MeasurementContext", {
    methods = {
        connection = lib.MeasurementContext_connection,
        instrument_type = lib.MeasurementContext_instrument_type,
    }
}, MeasurementContext)

return MeasurementContext
