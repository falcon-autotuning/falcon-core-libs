-- porttransforms.lua
-- Auto-generated wrapper for PortTransforms
-- Generated from PortTransforms_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local PortTransforms = {}

-- Constructors

function PortTransforms.from_json_string(json)
    return cdef.lib.PortTransforms_from_json_string(json)
end

function PortTransforms.empty()
    return cdef.lib.PortTransforms_create_empty()
end

function PortTransforms.new(handle)
    return cdef.lib.PortTransforms_create(handle)
end


-- Methods

function PortTransforms.copy(handle)
    return cdef.lib.PortTransforms_copy(handle)
end

function PortTransforms.to_json_string(handle)
    return cdef.lib.PortTransforms_to_json_string(handle)
end

function PortTransforms.from_json_string(handle)
    return cdef.lib.PortTransforms_from_json_string(handle)
end

function PortTransforms.create_empty(handle)
    return cdef.lib.PortTransforms_create_empty(handle)
end

function PortTransforms.create(handle)
    return cdef.lib.PortTransforms_create(handle)
end


return PortTransforms
