-- voltageconstraints.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local VoltageConstraints = {}

song.register("VoltageConstraints", {
    methods = {
        matrix = lib.VoltageConstraints_matrix,
        adjacency = lib.VoltageConstraints_adjacency,
        limits = lib.VoltageConstraints_limits,
    }
}, VoltageConstraints)

return VoltageConstraints
