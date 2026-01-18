-- voltagestatesresponse.lua
-- Auto-generated wrapper for VoltageStatesResponse
-- Generated from VoltageStatesResponse_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local VoltageStatesResponse = {}

-- Constructors


-- Methods

function VoltageStatesResponse.message(handle)
    return cdef.lib.VoltageStatesResponse_message(handle)
end


return VoltageStatesResponse
