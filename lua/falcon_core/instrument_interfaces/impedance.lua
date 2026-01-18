-- impedance.lua
-- Auto-generated wrapper for Impedance
-- Generated from Impedance_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Impedance = {}

-- Constructors

function Impedance.from_json_string(json)
    return cdef.lib.Impedance_from_json_string(json)
end


-- Methods

function Impedance.copy(handle)
    return cdef.lib.Impedance_copy(handle)
end

function Impedance.equal(handle, other)
    return cdef.lib.Impedance_equal(handle, other)
end

function Impedance.not_equal(handle, other)
    return cdef.lib.Impedance_not_equal(handle, other)
end

function Impedance.to_json_string(handle)
    return cdef.lib.Impedance_to_json_string(handle)
end

function Impedance.from_json_string(handle)
    return cdef.lib.Impedance_from_json_string(handle)
end


return Impedance
