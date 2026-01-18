-- falcon_core/init.lua
-- Main entry point for falcon-core Lua library

local M = {}

-- Load FFI bindings first
M.ffi = require("falcon_core.ffi.cdef").ffi
M.lib = require("falcon_core.ffi.cdef").lib

-- Load generic type dispatchers
M.generic = {
    FArray = require("falcon_core.generic.farray"),
    List = require("falcon_core.generic.list"),
    Map = require("falcon_core.generic.map"),
    Pair = require("falcon_core.generic.pair"),
    Axes = require("falcon_core.generic.axes"),
}

-- Load domain modules (reorganized to match C-API structure)
M.math = require("falcon_core.math")
M.autotuner_interfaces = require("falcon_core.autotuner_interfaces")
M.instrument_interfaces = require("falcon_core.instrument_interfaces")
M.communications = require("falcon_core.communications")
M.physics = require("falcon_core.physics")
M.io = require("falcon_core.io")

-- Utilities
M.utils = {
    song = require("falcon_core.utils.song"),
    memory = require("falcon_core.utils.memory"),
}

return M
