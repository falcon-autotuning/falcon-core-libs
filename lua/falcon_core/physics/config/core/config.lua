-- physics/config.lua
-- Wrapper for Config type (quantum device configuration)

local cdef = require("falcon_core.ffi.cdef")
local ffi = cdef.ffi
local lib = cdef.lib

local Config = {}

-- Internal helper: convert C StringHandle to Lua string and cleanup
local function to_lua_string(handle)
    if handle == nil then return nil end
    local lua_str = ffi.string(handle.raw, handle.length)
    lib.String_destroy(handle)
    return lua_str
end

-- Constructors

-- Create new config with optional components
-- @param opts table: Optional components { screening_gates, plunger_gates, ohmics, barrier_gates, reservoir_gates, groups, wiring_dc, constraints }
function Config.new(opts)
    opts = opts or {}
    
    local screening_gates = opts.screening_gates or lib.Connections_create_empty()
    local plunger_gates = opts.plunger_gates or lib.Connections_create_empty()
    local ohmics = opts.ohmics or lib.Connections_create_empty()
    local barrier_gates = opts.barrier_gates or lib.Connections_create_empty()
    local reservoir_gates = opts.reservoir_gates or lib.Connections_create_empty()
    local groups = opts.groups or lib.MapGnameGroup_create_empty()
    local wiring_dc = opts.wiring_dc or lib.Impedances_create_empty()
    local constraints = opts.constraints or ffi.cast("VoltageConstraintsHandle", nil)
    
    return lib.Config_create(
        screening_gates,
        plunger_gates,
        ohmics,
        barrier_gates,
        reservoir_gates,
        groups,
        wiring_dc,
        constraints
    )
end

-- Load config from JSON string
function Config.from_json_string(json_str)
    local path_handle = lib.String_wrap(json_str)
    local handle = lib.Config_from_json_string(path_handle)
    lib.String_destroy(path_handle) -- Cleanup wrap
    return handle
end

-- Load config from file
-- @param config_path string: Path to config file (YAML/JSON)
function Config.load(config_path)
    local Loader = require("falcon_core.io.loader")
    local loader = Loader.new(config_path)
    return Loader.config(loader)
end

-- Instance Methods (attached via metatype)

function Config.groups(cfg)
    return lib.Config_groups(cfg)
end

function Config.adjacency(cfg)
    return lib.Config_adjacency(cfg)
end

function Config.to_json_string(cfg)
    return to_lua_string(lib.Config_to_json_string(cfg))
end

-- Add more getters for a "nicer" interface
function Config.screening_gates(cfg) return lib.Config_screening_gates(cfg) end
function Config.plunger_gates(cfg) return lib.Config_plunger_gates(cfg) end
function Config.ohmics(cfg) return lib.Config_ohmics(cfg) end
function Config.barrier_gates(cfg) return lib.Config_barrier_gates(cfg) end
function Config.reservoir_gates(cfg) return lib.Config_reservoir_gates(cfg) end

-- Bind metatype so handle:method() works
ffi.metatype("Config_s", {
    __index = function(t, k)
        -- Support both handle:method() and handle.method
        return Config[k]
    end,
    __tostring = Config.to_json_string,
    __gc = lib.Config_destroy
})

return Config
