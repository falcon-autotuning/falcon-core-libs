-- standardrequest.lua
-- Auto-generated wrapper for StandardRequest
-- Generated from StandardRequest_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local StandardRequest = {}

-- Constructors

function StandardRequest.from_json_string(json)
    return cdef.lib.StandardRequest_from_json_string(json)
end

function StandardRequest.new(message)
    return cdef.lib.StandardRequest_create(message)
end


-- Methods

function StandardRequest.copy(handle)
    return cdef.lib.StandardRequest_copy(handle)
end

function StandardRequest.to_json_string(handle)
    return cdef.lib.StandardRequest_to_json_string(handle)
end

function StandardRequest.from_json_string(handle)
    return cdef.lib.StandardRequest_from_json_string(handle)
end

function StandardRequest.create(handle)
    return cdef.lib.StandardRequest_create(handle)
end

function StandardRequest.message(handle)
    return cdef.lib.StandardRequest_message(handle)
end


return StandardRequest
