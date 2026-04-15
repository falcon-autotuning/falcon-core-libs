-- unitspace.lua
local cdef = require("falcon-core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon-core.utils.song")
local UnitSpace = {}

song.register("UnitSpace", {
    methods = {
        dimension = lib.UnitSpace_dimension,
        axes = lib.UnitSpace_axes,
        domain = lib.UnitSpace_domain,
        space = lib.UnitSpace_space,
        shape = lib.UnitSpace_shape,
        size = function(t) return tonumber(lib.UnitSpace_size(t)) end,
        at = lib.UnitSpace_at,
    }
}, UnitSpace)

return UnitSpace
