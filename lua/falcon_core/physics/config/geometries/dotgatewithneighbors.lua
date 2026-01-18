-- dotgatewithneighbors.lua
-- Auto-generated wrapper for DotGateWithNeighbors
-- Generated from DotGateWithNeighbors_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local DotGateWithNeighbors = {}

-- Constructors


-- Methods

function DotGateWithNeighbors.name(handle)
    return cdef.lib.DotGateWithNeighbors_name(handle)
end

function DotGateWithNeighbors.type(handle)
    return cdef.lib.DotGateWithNeighbors_type(handle)
end

function DotGateWithNeighbors.is_barrier_gate(handle)
    return cdef.lib.DotGateWithNeighbors_is_barrier_gate(handle)
end

function DotGateWithNeighbors.is_plunger_gate(handle)
    return cdef.lib.DotGateWithNeighbors_is_plunger_gate(handle)
end


return DotGateWithNeighbors
