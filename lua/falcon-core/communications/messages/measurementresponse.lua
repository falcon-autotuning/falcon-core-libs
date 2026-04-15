-- measurementresponse.lua
local cdef = require("falcon-core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon-core.utils.song")
local MeasurementResponse = {}

song.register("MeasurementResponse", {
    methods = {
        arrays = lib.MeasurementResponse_arrays,
        message = lib.MeasurementResponse_message,
    }
}, MeasurementResponse)

return MeasurementResponse
