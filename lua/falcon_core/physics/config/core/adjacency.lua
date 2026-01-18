-- adjacency.lua
-- Auto-generated wrapper for Adjacency
-- Generated from Adjacency_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Adjacency = {}

-- Constructors

function Adjacency.from_json_string(json)
    return cdef.lib.Adjacency_from_json_string(json)
end


-- Methods

function Adjacency.copy(handle)
    return cdef.lib.Adjacency_copy(handle)
end

function Adjacency.equal(handle, other)
    return cdef.lib.Adjacency_equal(handle, other)
end

function Adjacency.not_equal(handle, other)
    return cdef.lib.Adjacency_not_equal(handle, other)
end

function Adjacency.to_json_string(handle)
    return cdef.lib.Adjacency_to_json_string(handle)
end

function Adjacency.from_json_string(handle)
    return cdef.lib.Adjacency_from_json_string(handle)
end


return Adjacency
