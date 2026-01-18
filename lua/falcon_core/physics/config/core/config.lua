-- physics/config.lua
-- Wrapper for Config type (quantum device configuration)

local cdef = require("falcon_core.ffi.cdef")

local Config = {}

-- Create empty config
function Config.new()
    return cdef.lib.Config_create()
end

-- Get groups
function Config.groups(cfg)
    return cdef.lib.Config_groups(cfg)
end

-- Get adjacency
function Config.adjacency(cfg)
    return cdef.lib.Config_adjacency(cfg)
end

return Config
