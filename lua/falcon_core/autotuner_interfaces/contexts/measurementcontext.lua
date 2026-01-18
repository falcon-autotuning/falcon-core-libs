-- measurementcontext.lua
-- Auto-generated wrapper for MeasurementContext
-- Generated from MeasurementContext_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local MeasurementContext = {}

-- Constructors

function MeasurementContext.from_json_string(json)
    return cdef.lib.MeasurementContext_from_json_string(json)
end


-- Methods

function MeasurementContext.to_json_string(handle)
    return cdef.lib.MeasurementContext_to_json_string(handle)
end

function MeasurementContext.from_json_string(handle)
    return cdef.lib.MeasurementContext_from_json_string(handle)
end

function MeasurementContext.connection(handle)
    return cdef.lib.MeasurementContext_connection(handle)
end


return MeasurementContext
