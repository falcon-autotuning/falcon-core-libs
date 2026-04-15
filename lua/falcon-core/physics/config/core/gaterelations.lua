-- gaterelations.lua
local cdef = require("falcon-core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon-core.utils.song")
local GateRelations = {}
function GateRelations.new() return lib.GateRelations_create_empty() end
song.register("GateRelations", {
    methods = {
        size = function(t) return tonumber(lib.GateRelations_size(t)) end,
        depends_on = lib.GateRelations_contains,
        get_dependencies = lib.GateRelations_at,
    }
}, GateRelations)
return GateRelations
