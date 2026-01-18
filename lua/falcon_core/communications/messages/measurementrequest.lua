-- measurementrequest.lua
-- Auto-generated wrapper for MeasurementRequest
-- Generated from MeasurementRequest_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local MeasurementRequest = {}

-- Constructors

function MeasurementRequest.from_json_string(json)
    return cdef.lib.MeasurementRequest_from_json_string(json)
end


-- Methods

function MeasurementRequest.to_json_string(handle)
    return cdef.lib.MeasurementRequest_to_json_string(handle)
end

function MeasurementRequest.from_json_string(handle)
    return cdef.lib.MeasurementRequest_from_json_string(handle)
end

function MeasurementRequest.getters(handle)
    return cdef.lib.MeasurementRequest_getters(handle)
end

function MeasurementRequest.message(handle)
    return cdef.lib.MeasurementRequest_message(handle)
end


return MeasurementRequest
