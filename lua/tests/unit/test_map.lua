-- tests/unit/test_map.lua
-- Comprehensive tests for Map<K,V> dispatcher

package.path = "../?.lua;../?/init.lua;" .. package.path

local Map = require("falcon_core.generic.map")

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

describe("Map.supported_types", function()
    it("returns all 14 supported types", function()
        local types = Map.supported_types()
        assert(#types == 14, "Should have 14 types, got " .. #types)
    end)
end)

describe("Map.new", function()
    it("creates MapStringDouble", function()
        local map = Map.new("string_double")
        assert(map ~= nil, "Map should be created")
    end)
    
    it("creates MapStringString", function()
        local map = Map.new("string_string")
        assert(map ~= nil, "Map should be created")
    end)
    
    it("creates MapIntInt", function()
        local map = Map.new("int_int")
        assert(map ~= nil, "Map should be created")
    end)
    
    it("creates MapConnectionQuantity", function()
        local map = Map.new("connection_quantity")
        assert(map ~= nil, "Map should be created")
    end)
    
    it("errors on unknown type", function()
        local ok = pcall(function()
            Map.new("unknown_unknown")
        end)
        assert(not ok, "Should error on unknown type")
    end)
end)

print("\n✓ Map tests complete")
