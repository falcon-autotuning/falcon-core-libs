-- math/point.lua
-- Wrapper for Point type (geometric point with units)

local cdef = require("falcon_core.ffi.cdef")

local Point = {}

-- Create from map of connection -> quantity
function Point.new(coordinates_map)
    local lib = cdef.lib
    return lib.Point_create_from_parent(coordinates_map)
end

-- Insert or assign coordinate
function Point.set(p, connection, quantity)
    cdef.lib.Point_insert_or_assign(p, connection, quantity)
end

-- Get coordinate
function Point.get(p, connection)
    return cdef.lib.Point_at(p, connection)
end

-- Get all coordinates as map
function Point.coordinates(p)
    return cdef.lib.Point_coordinates(p)
end

-- Get list of all values
function Point.values(p)
    return cdef.lib.Point_values(p)
end

return Point
