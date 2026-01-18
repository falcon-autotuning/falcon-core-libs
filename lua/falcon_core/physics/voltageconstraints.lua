-- voltageconstraints.lua
-- Auto-generated wrapper for VoltageConstraints
-- Generated from VoltageConstraints_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local VoltageConstraints = {}

-- Constructors

function VoltageConstraints.from_json_string(json)
    return cdef.lib.VoltageConstraints_from_json_string(json)
end


-- Methods

function VoltageConstraints.to_json_string(handle)
    return cdef.lib.VoltageConstraints_to_json_string(handle)
end

function VoltageConstraints.from_json_string(handle)
    return cdef.lib.VoltageConstraints_from_json_string(handle)
end

function VoltageConstraints.matrix(handle)
    return cdef.lib.VoltageConstraints_matrix(handle)
end

function VoltageConstraints.adjacency(handle)
    return cdef.lib.VoltageConstraints_adjacency(handle)
end

function VoltageConstraints.limits(handle)
    return cdef.lib.VoltageConstraints_limits(handle)
end


return VoltageConstraints
