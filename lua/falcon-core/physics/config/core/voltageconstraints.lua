-- voltageconstraints.lua
local cdef = require("falcon-core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon-core.utils.song")
local VoltageConstraints = {}

song.register("VoltageConstraints", {
    methods = {
        matrix = lib.VoltageConstraints_matrix,
        adjacency = lib.VoltageConstraints_adjacency,
        limits = lib.VoltageConstraints_limits,
    }
}, VoltageConstraints)

return VoltageConstraints
