-- adjacency.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Adjacency = {}

song.register("Adjacency", {
    methods = {
        indexes = lib.Adjacency_indexes,
        get_true_pairs = lib.Adjacency_get_true_pairs,
        size = function(t) return tonumber(lib.Adjacency_size(t)) end,
        dimension = lib.Adjacency_dimension,
        sum = lib.Adjacency_sum,
        where = lib.Adjacency_where,
    }
}, Adjacency)

return Adjacency
