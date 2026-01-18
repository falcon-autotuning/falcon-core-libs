-- channels.lua
-- Auto-generated wrapper for Channels
-- Generated from Channels_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Channels = {}

-- Constructors

function Channels.from_json_string(json)
    return cdef.lib.Channels_from_json_string(json)
end

function Channels.empty()
    return cdef.lib.Channels_create_empty()
end

function Channels.new(items)
    return cdef.lib.Channels_create(items)
end


-- Methods

function Channels.copy(handle)
    return cdef.lib.Channels_copy(handle)
end

function Channels.equal(handle, other)
    return cdef.lib.Channels_equal(handle, other)
end

function Channels.not_equal(handle, other)
    return cdef.lib.Channels_not_equal(handle, other)
end

function Channels.to_json_string(handle)
    return cdef.lib.Channels_to_json_string(handle)
end

function Channels.from_json_string(handle)
    return cdef.lib.Channels_from_json_string(handle)
end


return Channels
