-- standardresponse.lua
-- Auto-generated wrapper for StandardResponse
-- Generated from StandardResponse_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local StandardResponse = {}

-- Constructors

function StandardResponse.from_json_string(json)
    return cdef.lib.StandardResponse_from_json_string(json)
end

function StandardResponse.new(message)
    return cdef.lib.StandardResponse_create(message)
end


-- Methods

function StandardResponse.copy(handle)
    return cdef.lib.StandardResponse_copy(handle)
end

function StandardResponse.to_json_string(handle)
    return cdef.lib.StandardResponse_to_json_string(handle)
end

function StandardResponse.from_json_string(handle)
    return cdef.lib.StandardResponse_from_json_string(handle)
end

function StandardResponse.create(handle)
    return cdef.lib.StandardResponse_create(handle)
end

function StandardResponse.message(handle)
    return cdef.lib.StandardResponse_message(handle)
end


return StandardResponse
