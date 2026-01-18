-- discretespace.lua
-- Auto-generated wrapper for DiscreteSpace
-- Generated from DiscreteSpace_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local DiscreteSpace = {}

-- Constructors

function DiscreteSpace.from_json_string(json)
    return cdef.lib.DiscreteSpace_from_json_string(json)
end


-- Methods

function DiscreteSpace.copy(handle)
    return cdef.lib.DiscreteSpace_copy(handle)
end

function DiscreteSpace.equal(handle, other)
    return cdef.lib.DiscreteSpace_equal(handle, other)
end

function DiscreteSpace.to_json_string(handle)
    return cdef.lib.DiscreteSpace_to_json_string(handle)
end

function DiscreteSpace.from_json_string(handle)
    return cdef.lib.DiscreteSpace_from_json_string(handle)
end

function DiscreteSpace.space(handle)
    return cdef.lib.DiscreteSpace_space(handle)
end


return DiscreteSpace
