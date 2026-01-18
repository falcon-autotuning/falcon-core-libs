-- point.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Point = {}
function Point.new(values)
    local Mapping = require("falcon_core.utils.mapping")
    local map = Mapping.to_map_connection_quantity(values)
    local handle = lib.Point_create_from_parent(map)
    lib.MapConnectionQuantity_destroy(map)
    return handle
end
song.register("Point", {
    methods = {
        at = lib.Point_at,
        contains = lib.Point_contains,
        size = function(t) return tonumber(lib.Point_size(t)) end,
    }
}, Point)
return Point
