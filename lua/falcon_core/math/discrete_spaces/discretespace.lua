-- discretespace.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local DiscreteSpace = {}

song.register("DiscreteSpace", {
    methods = {
        space = lib.DiscreteSpace_space,
        axes = lib.DiscreteSpace_axes,
        increasing = lib.DiscreteSpace_increasing,
        knobs = lib.DiscreteSpace_knobs,
        get_axis = lib.DiscreteSpace_get_axis,
        get_domain = lib.DiscreteSpace_get_domain,
    }
}, DiscreteSpace)

return DiscreteSpace
