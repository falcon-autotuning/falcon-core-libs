-- measurementresponse.lua
-- Auto-generated wrapper for MeasurementResponse
-- Generated from MeasurementResponse_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local MeasurementResponse = {}

-- Constructors


-- Methods

function MeasurementResponse.message(handle)
    return cdef.lib.MeasurementResponse_message(handle)
end


return MeasurementResponse
