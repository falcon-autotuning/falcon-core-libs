require("luacov")
-- tests/unit/test_physics.lua
-- Tests for physics module

local physics = require("falcon_core.physics")
local Config = physics.config.core.Config
local Adjacency = physics.config.core.Adjacency

local function describe(name, fn) print("\n" .. name); fn() end
local function it(name, fn) 
    local ok, err = pcall(fn)
    if ok then
        print("  ✓ " .. name)
    else
        print("  ✗ " .. name)
        print("    " .. tostring(err))
    end
end
local function assert(cond, msg)
    if not cond then error(msg or "Assertion failed") end
end

describe("Config", function()
    it("module loads successfully", function()
        assert(Config ~= nil, "Config should load")
        assert(Config.new ~= nil, "Should have new method")
    end)
    
    it("can create Config instance with empty components", function()
        local connections = require("falcon_core.instrument_interfaces.connections")
        local impedances = require("falcon_core.instrument_interfaces.impedances")
        local empty_conn = connections.new()
        local empty_imp = impedances.new()
        
        local cfg = Config.new({
            screening_gates = empty_conn,
            plunger_gates = empty_conn,
            ohmics = empty_conn,
            barrier_gates = empty_conn,
            reservoir_gates = empty_conn,
            wiring_dc = empty_imp
        })
        assert(cfg ~= nil, "Config should be created with explicit empty components")
    end)
end)

print("\n✓ Physics module tests complete")
