-- unitspace.lua
-- Auto-generated wrapper for UnitSpace
-- Generated from UnitSpace_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local UnitSpace = {}

-- Constructors

function UnitSpace.from_json_string(json)
    return cdef.lib.UnitSpace_from_json_string(json)
end


-- Methods

function UnitSpace.copy(handle)
    return cdef.lib.UnitSpace_copy(handle)
end

function UnitSpace.equal(handle, other)
    return cdef.lib.UnitSpace_equal(handle, other)
end

function UnitSpace.not_equal(handle, other)
    return cdef.lib.UnitSpace_not_equal(handle, other)
end

function UnitSpace.to_json_string(handle)
    return cdef.lib.UnitSpace_to_json_string(handle)
end

function UnitSpace.from_json_string(handle)
    return cdef.lib.UnitSpace_from_json_string(handle)
end


return UnitSpace
