-- gaterelations.lua
-- Auto-generated wrapper for GateRelations
-- Generated from GateRelations_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local GateRelations = {}

-- Constructors

function GateRelations.from_json_string(json)
    return cdef.lib.GateRelations_from_json_string(json)
end

function GateRelations.empty()
    return cdef.lib.GateRelations_create_empty()
end


-- Methods

function GateRelations.copy(handle)
    return cdef.lib.GateRelations_copy(handle)
end

function GateRelations.equal(handle, other)
    return cdef.lib.GateRelations_equal(handle, other)
end

function GateRelations.to_json_string(handle)
    return cdef.lib.GateRelations_to_json_string(handle)
end

function GateRelations.from_json_string(handle)
    return cdef.lib.GateRelations_from_json_string(handle)
end

function GateRelations.create_empty(handle)
    return cdef.lib.GateRelations_create_empty(handle)
end


return GateRelations
