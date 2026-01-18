-- discretizer.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Discretizer = {}

song.register("Discretizer", {
    methods = {
        domain = lib.Discretizer_domain,
        delta = lib.Discretizer_delta,
        is_cartesian = lib.Discretizer_is_cartesian,
        is_polar = lib.Discretizer_is_polar,
    }
}, Discretizer)

return Discretizer
