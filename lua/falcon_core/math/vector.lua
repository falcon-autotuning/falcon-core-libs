-- vector.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Vector = {}

function Vector.new(start_point, end_point)
    local Point = require("falcon_core.math.point")
    local s_pt = type(start_point) == "table" and Point.new(start_point) or start_point
    local e_pt = type(end_point) == "table" and Point.new(end_point) or end_point
    
    local handle = lib.Vector_create(s_pt, e_pt)
    return handle
end

song.register("Vector", {
    methods = {
        start_point = lib.Vector_start_point,
        end_point = lib.Vector_end_point,
    }
}, Vector)

return Vector
