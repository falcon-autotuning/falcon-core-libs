-- channel.lua
-- Auto-generated wrapper for Channel
-- Generated from Channel_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Channel = {}

-- Constructors

function Channel.from_json_string(json)
    return cdef.lib.Channel_from_json_string(json)
end

function Channel.new(name)
    return cdef.lib.Channel_create(name)
end


-- Methods

function Channel.copy(handle)
    return cdef.lib.Channel_copy(handle)
end

function Channel.equal(handle, other)
    return cdef.lib.Channel_equal(handle, other)
end

function Channel.not_equal(handle, other)
    return cdef.lib.Channel_not_equal(handle, other)
end

function Channel.to_json_string(handle)
    return cdef.lib.Channel_to_json_string(handle)
end

function Channel.from_json_string(handle)
    return cdef.lib.Channel_from_json_string(handle)
end


return Channel
