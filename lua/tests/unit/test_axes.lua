-- tests/unit/test_axes.lua
-- Comprehensive tests for Axes<T> dispatcher

package.path = "../?.lua;../?/init.lua;" .. package.path

local Axes = require("falcon_core.generic.axes")

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

describe("Axes.supported_types", function()
    it("returns all 13 supported types", function()
        local types = Axes.supported_types()
        assert(#types == 13, "Should have 13 types, got " .. #types)
    end)
end)

describe("Axes.new", function()
    it("creates AxesDouble", function()
        local axes = Axes.new("double")
        assert(axes ~= nil, "Axes should be created")
    end)
    
    it("creates AxesInt", function()
        local axes = Axes.new("int")
        assert(axes ~= nil, "Axes should be created")
    end)
    
    it("errors on unknown type", function()
        local ok = pcall(function()
            Axes.new("unknown")
        end)
        assert(not ok, "Should error on unknown type")
    end)
end)

print("\n✓ Axes tests complete")
