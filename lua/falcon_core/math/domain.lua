-- domain.lua
-- Auto-generated wrapper for Domain
-- Generated from Domain_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Domain = {}

-- Constructors

function Domain.from_json_string(json)
    return cdef.lib.Domain_from_json_string(json)
end


-- Methods

function Domain.copy(handle)
    return cdef.lib.Domain_copy(handle)
end

function Domain.equal(handle, other)
    return cdef.lib.Domain_equal(handle, other)
end

function Domain.not_equal(handle, other)
    return cdef.lib.Domain_not_equal(handle, other)
end

function Domain.to_json_string(handle)
    return cdef.lib.Domain_to_json_string(handle)
end

function Domain.from_json_string(handle)
    return cdef.lib.Domain_from_json_string(handle)
end


return Domain
