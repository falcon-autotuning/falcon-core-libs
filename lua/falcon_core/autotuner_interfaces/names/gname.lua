-- gname.lua
-- Auto-generated wrapper for Gname
-- Generated from Gname_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Gname = {}

-- Constructors

function Gname.from_json_string(json)
    return cdef.lib.Gname_from_json_string(json)
end

function Gname.from_num(num)
    return cdef.lib.Gname_create_from_num(num)
end

function Gname.new(name)
    return cdef.lib.Gname_create(name)
end


-- Methods

function Gname.copy(handle)
    return cdef.lib.Gname_copy(handle)
end

function Gname.equal(handle, other)
    return cdef.lib.Gname_equal(handle, other)
end

function Gname.not_equal(handle, other)
    return cdef.lib.Gname_not_equal(handle, other)
end

function Gname.to_json_string(handle)
    return cdef.lib.Gname_to_json_string(handle)
end

function Gname.from_json_string(handle)
    return cdef.lib.Gname_from_json_string(handle)
end


return Gname
