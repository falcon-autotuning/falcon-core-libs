-- tests/unit/test_instrument.lua
-- Tests for instrument module

local instrument = require("falcon_core.instrument")
local Port = instrument.Port
local Connection = instrument.Connection

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

describe("Port", function()
    it("module loads successfully", function()
        assert(Port ~= nil, "Port should load")
        assert(Port.name ~= nil, "Should have name method")
    end)
end)

describe("Connection", function()
    it("module loads successfully", function()
        assert(Connection ~= nil, "Connection should load")
        assert(Connection.name ~= nil, "Should have name method")
    end)
end)

print("\n✓ Instrument module tests complete")
