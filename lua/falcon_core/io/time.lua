-- time.lua
-- Auto-generated wrapper for Time
-- Generated from Time_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Time = {}

-- Constructors

function Time.from_json_string(json)
    return cdef.lib.Time_from_json_string(json)
end

function Time.now()
    return cdef.lib.Time_create_now()
end

function Time.at(micro_seconds_since_epoch)
    return cdef.lib.Time_create_at(micro_seconds_since_epoch)
end


-- Methods

function Time.copy(handle)
    return cdef.lib.Time_copy(handle)
end

function Time.equal(handle, other)
    return cdef.lib.Time_equal(handle, other)
end

function Time.not_equal(handle, other)
    return cdef.lib.Time_not_equal(handle, other)
end

function Time.to_json_string(handle)
    return cdef.lib.Time_to_json_string(handle)
end

function Time.from_json_string(handle)
    return cdef.lib.Time_from_json_string(handle)
end


return Time
