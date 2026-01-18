-- group.lua
-- Auto-generated wrapper for Group
-- Generated from Group_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Group = {}

-- Constructors

function Group.from_json_string(json)
    return cdef.lib.Group_from_json_string(json)
end


-- Methods

function Group.copy(handle)
    return cdef.lib.Group_copy(handle)
end

function Group.equal(handle, other)
    return cdef.lib.Group_equal(handle, other)
end

function Group.not_equal(handle, other)
    return cdef.lib.Group_not_equal(handle, other)
end

function Group.to_json_string(handle)
    return cdef.lib.Group_to_json_string(handle)
end

function Group.from_json_string(handle)
    return cdef.lib.Group_from_json_string(handle)
end


return Group
