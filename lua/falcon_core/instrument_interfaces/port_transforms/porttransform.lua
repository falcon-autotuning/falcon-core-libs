-- porttransform.lua
-- Auto-generated wrapper for PortTransform
-- Generated from PortTransform_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local PortTransform = {}

-- Constructors

function PortTransform.from_json_string(json)
    return cdef.lib.PortTransform_from_json_string(json)
end


-- Methods

function PortTransform.copy(handle)
    return cdef.lib.PortTransform_copy(handle)
end

function PortTransform.equal(handle, other)
    return cdef.lib.PortTransform_equal(handle, other)
end

function PortTransform.to_json_string(handle)
    return cdef.lib.PortTransform_to_json_string(handle)
end

function PortTransform.from_json_string(handle)
    return cdef.lib.PortTransform_from_json_string(handle)
end

function PortTransform.port(handle)
    return cdef.lib.PortTransform_port(handle)
end


return PortTransform
