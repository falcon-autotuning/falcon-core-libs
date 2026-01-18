-- math/vector.lua
-- Wrapper for Vector type (geometric vector with units)

local cdef = require("falcon_core.ffi.cdef")

local Vector = {}

-- Create from quantities (start and end points)
function Vector.from_quantities(start_map, end_map)
    local lib = cdef.lib
    return lib.Vector_create_from_quantities(start_map, end_map)
end

-- Create from end point only
function Vector.from_end(end_map)
    local lib = cdef.lib
    return lib.Vector_create_from_end_quantities(end_map)
end

-- Get start/end quantities
function Vector.start_quantities(v)
    return cdef.lib.Vector_start_quantities(v)
end

function Vector.end_quantities(v)
    return cdef.lib.Vector_end_quantities(v)
end

-- Translate by point
function Vector.translate(v, point_map)
    return cdef.lib.Vector_translate_quantities(v, point_map)
end

return Vector
