-- ports.lua
-- Auto-generated wrapper for Ports
-- Generated from Ports_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Ports = {}

-- Constructors

function Ports.from_json_string(json)
    return cdef.lib.Ports_from_json_string(json)
end

function Ports.empty()
    return cdef.lib.Ports_create_empty()
end

function Ports.new(items)
    return cdef.lib.Ports_create(items)
end


-- Methods

function Ports.copy(handle)
    return cdef.lib.Ports_copy(handle)
end

function Ports.equal(handle, other)
    return cdef.lib.Ports_equal(handle, other)
end

function Ports.not_equal(handle, other)
    return cdef.lib.Ports_not_equal(handle, other)
end

function Ports.to_json_string(handle)
    return cdef.lib.Ports_to_json_string(handle)
end

function Ports.from_json_string(handle)
    return cdef.lib.Ports_from_json_string(handle)
end


return Ports
