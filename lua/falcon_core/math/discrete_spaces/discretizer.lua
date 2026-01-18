-- discretizer.lua
-- Auto-generated wrapper for Discretizer
-- Generated from Discretizer_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Discretizer = {}

-- Constructors

function Discretizer.from_json_string(json)
    return cdef.lib.Discretizer_from_json_string(json)
end

function Discretizer.cartesian_discretizer(delta)
    return cdef.lib.Discretizer_create_cartesian_discretizer(delta)
end

function Discretizer.polar_discretizer(delta)
    return cdef.lib.Discretizer_create_polar_discretizer(delta)
end


-- Methods

function Discretizer.copy(handle)
    return cdef.lib.Discretizer_copy(handle)
end

function Discretizer.equal(handle, other)
    return cdef.lib.Discretizer_equal(handle, other)
end

function Discretizer.not_equal(handle, other)
    return cdef.lib.Discretizer_not_equal(handle, other)
end

function Discretizer.to_json_string(handle)
    return cdef.lib.Discretizer_to_json_string(handle)
end

function Discretizer.from_json_string(handle)
    return cdef.lib.Discretizer_from_json_string(handle)
end


return Discretizer
