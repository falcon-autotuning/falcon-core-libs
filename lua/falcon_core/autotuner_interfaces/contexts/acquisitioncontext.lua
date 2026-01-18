-- acquisitioncontext.lua
-- Auto-generated wrapper for AcquisitionContext
-- Generated from AcquisitionContext_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local AcquisitionContext = {}

-- Constructors

function AcquisitionContext.from_json_string(json)
    return cdef.lib.AcquisitionContext_from_json_string(json)
end


-- Methods

function AcquisitionContext.to_json_string(handle)
    return cdef.lib.AcquisitionContext_to_json_string(handle)
end

function AcquisitionContext.from_json_string(handle)
    return cdef.lib.AcquisitionContext_from_json_string(handle)
end

function AcquisitionContext.connection(handle)
    return cdef.lib.AcquisitionContext_connection(handle)
end

function AcquisitionContext.units(handle)
    return cdef.lib.AcquisitionContext_units(handle)
end


return AcquisitionContext
