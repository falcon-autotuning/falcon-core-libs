-- impedances.lua
-- Auto-generated wrapper for Impedances
-- Generated from Impedances_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Impedances = {}

-- Constructors

function Impedances.from_json_string(json)
    return cdef.lib.Impedances_from_json_string(json)
end

function Impedances.empty()
    return cdef.lib.Impedances_create_empty()
end

function Impedances.new(items)
    return cdef.lib.Impedances_create(items)
end


-- Methods

function Impedances.copy(handle)
    return cdef.lib.Impedances_copy(handle)
end

function Impedances.equal(handle, other)
    return cdef.lib.Impedances_equal(handle, other)
end

function Impedances.not_equal(handle, other)
    return cdef.lib.Impedances_not_equal(handle, other)
end

function Impedances.to_json_string(handle)
    return cdef.lib.Impedances_to_json_string(handle)
end

function Impedances.from_json_string(handle)
    return cdef.lib.Impedances_from_json_string(handle)
end


return Impedances
