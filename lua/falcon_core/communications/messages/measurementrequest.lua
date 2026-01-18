-- measurementrequest.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local MeasurementRequest = {}

song.register("MeasurementRequest", {
    methods = {
        measurement_name = lib.MeasurementRequest_measurement_name,
        getters = lib.MeasurementRequest_getters,
        waveforms = lib.MeasurementRequest_waveforms,
        meter_transforms = lib.MeasurementRequest_meter_transforms,
        time_domain = lib.MeasurementRequest_time_domain,
        message = lib.MeasurementRequest_message,
    }
}, MeasurementRequest)

return MeasurementRequest
