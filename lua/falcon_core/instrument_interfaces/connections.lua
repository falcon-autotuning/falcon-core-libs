-- connections.lua
-- Auto-generated wrapper for Connections
-- Generated from Connections_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Connections = {}

-- Constructors

function Connections.from_json_string(json)
    return cdef.lib.Connections_from_json_string(json)
end

function Connections.empty()
    return cdef.lib.Connections_create_empty()
end

function Connections.new(items)
    return cdef.lib.Connections_create(items)
end


-- Methods

function Connections.copy(handle)
    return cdef.lib.Connections_copy(handle)
end

function Connections.equal(handle, other)
    return cdef.lib.Connections_equal(handle, other)
end

function Connections.not_equal(handle, other)
    return cdef.lib.Connections_not_equal(handle, other)
end

function Connections.to_json_string(handle)
    return cdef.lib.Connections_to_json_string(handle)
end

function Connections.from_json_string(handle)
    return cdef.lib.Connections_from_json_string(handle)
end


return Connections
