-- tests/unit/test_list.lua
-- Comprehensive tests for List<T> dispatcher

package.path = "../?.lua;../?/init.lua;" .. package.path

local List = require("falcon_core.generic.list")

-- Test helpers
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

describe("List.supported_types", function()
    it("returns all 50+ supported types", function()
        local types = List.supported_types()
        assert(#types >= 50, "Should have 50+ types, got " .. #types)
        assert(types[1], "Should have types")
    end)
end)

describe("List.new - primitive types", function()
    it("creates ListDouble", function()
        local list = List.new("double")
        assert(list ~= nil, "List should be created")
    end)
    
    it("creates ListInt", function()
        local list = List.new("int")
        assert(list ~= nil, "List should be created")
    end)
    
    it("creates ListString", function()
        local list = List.new("string")
        assert(list ~= nil, "List should be created")
    end)
end)

describe("List.new - domain types", function()
    it("creates ListQuantity", function()
        local list = List.new("quantity")
        assert(list ~= nil, "List should be created")
    end)
    
    it("creates ListConnection", function()
        local list = List.new("connection")
        assert(list ~= nil, "List should be created")
    end)
end)

describe("List.new - errors", function()
    it("errors on unknown type", function()
        local ok = pcall(function()
            List.new("unknown_type")
        end)
        assert(not ok, "Should error on unknown type")
    end)
end)

print("\n✓ List tests complete")
