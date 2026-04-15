-- impedances.lua
-- Wrapper for Impedances (collection of impedances)

local cdef = require("falcon-core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon-core.utils.song")

local Impedances = {}

-- Register extensions for Song
song.register("Impedances", {
    __len = function(t) return tonumber(lib.Impedances_size(t)) end,
    methods = {
        size = function(t) return tonumber(lib.Impedances_size(t)) end,
        at = lib.Impedances_at,
    }
})

return Impedances
