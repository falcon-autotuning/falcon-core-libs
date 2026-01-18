-- increasingalignment.lua
-- Auto-generated wrapper for IncreasingAlignment
-- Generated from IncreasingAlignment_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local IncreasingAlignment = {}

-- Constructors

function IncreasingAlignment.empty()
    return cdef.lib.IncreasingAlignment_create_empty()
end

function IncreasingAlignment.new(alignment)
    return cdef.lib.IncreasingAlignment_create(alignment)
end


-- Methods

function IncreasingAlignment.create_empty(handle)
    return cdef.lib.IncreasingAlignment_create_empty(handle)
end

function IncreasingAlignment.create(handle)
    return cdef.lib.IncreasingAlignment_create(handle)
end

function IncreasingAlignment.alignment(handle)
    return cdef.lib.IncreasingAlignment_alignment(handle)
end


return IncreasingAlignment
