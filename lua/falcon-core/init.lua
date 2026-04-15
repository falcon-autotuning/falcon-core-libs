-- falcon-core/init.lua
-- Main entry point for falcon-core Lua library

local M = {}

-- Load FFI bindings first
M.ffi = require("falcon-core.ffi.cdef").ffi
M.lib = require("falcon-core.ffi.cdef").lib

-- Load generic type dispatchers
M.generic = {
    FArray = require("falcon-core.generic.farray"),
    List = require("falcon-core.generic.list"),
    Map = require("falcon-core.generic.map"),
    Pair = require("falcon-core.generic.pair"),
    Axes = require("falcon-core.generic.axes"),
}

-- Load domain modules (reorganized to match C-API structure)
M.math = require("falcon-core.math")
M.autotuner_interfaces = require("falcon-core.autotuner_interfaces")
M.instrument_interfaces = require("falcon-core.instrument_interfaces")
M.communications = require("falcon-core.communications")
M.physics = require("falcon-core.physics")
M.io = require("falcon-core.io")

-- Utilities
M.utils = {
    song = require("falcon-core.utils.song"),
    memory = require("falcon-core.utils.memory"),
}

-- Initialize all metatypes (merges registered methods/operators)
M.utils.song.init(M.lib)

return M
