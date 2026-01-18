-- tests/unit/test_physics.lua
-- Tests for physics module

local physics = require("falcon_core.physics")
local Config = physics.Config

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
        assert(Config.groups ~= nil, "Should have groups method")
    end)
    
    it("can create Config instance", function()
        local cfg = Config.new()
        assert(cfg ~= nil, "Config should be created")
    end)
end)

print("\n✓ Physics module tests complete")
