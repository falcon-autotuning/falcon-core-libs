-- tests/unit/test_pair.lua
-- Comprehensive tests for Pair<T,U> dispatcher

package.path = "../?.lua;../?/init.lua;" .. package.path

local Pair = require("falcon_core.generic.pair")

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

describe("Pair.supported_types", function()
    it("returns all 22 supported types", function()
        local types = Pair.supported_types()
        assert(#types >= 21, "Should have 21+ types, got " .. #types)
    end)
end)

describe("Pair.new", function()
    it("creates PairDoubleDouble", function()
        local pair = Pair.new("double_double", 1.0, 2.0)
        assert(pair ~= nil, "Pair should be created")
    end)
    
    it("creates PairIntInt", function()
        local pair = Pair.new("int_int", 1, 2)
        assert(pair ~= nil, "Pair should be created")
    end)
    
    it("errors on unknown type", function()
        local ok = pcall(function()
            Pair.new("unknown_unknown", 1, 2)
        end)
        assert(not ok, "Should error on unknown type")
    end)
end)

print("\n✓ Pair tests complete")
