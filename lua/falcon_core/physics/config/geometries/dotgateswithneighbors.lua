-- dotgateswithneighbors.lua
-- Auto-generated wrapper for DotGatesWithNeighbors
-- Generated from DotGatesWithNeighbors_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local DotGatesWithNeighbors = {}

-- Constructors

function DotGatesWithNeighbors.empty()
    return cdef.lib.DotGatesWithNeighbors_create_empty()
end


-- Methods

function DotGatesWithNeighbors.create_empty(handle)
    return cdef.lib.DotGatesWithNeighbors_create_empty(handle)
end

function DotGatesWithNeighbors.is_plunger_gates(handle)
    return cdef.lib.DotGatesWithNeighbors_is_plunger_gates(handle)
end

function DotGatesWithNeighbors.is_barrier_gates(handle)
    return cdef.lib.DotGatesWithNeighbors_is_barrier_gates(handle)
end

function DotGatesWithNeighbors.size(handle)
    return cdef.lib.DotGatesWithNeighbors_size(handle)
end

function DotGatesWithNeighbors.empty(handle)
    return cdef.lib.DotGatesWithNeighbors_empty(handle)
end


return DotGatesWithNeighbors
