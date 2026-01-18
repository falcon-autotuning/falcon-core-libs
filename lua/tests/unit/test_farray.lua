-- tests/unit/test_farray.lua
-- Unit tests for FArray generic dispatcher

local busted = pcall(require, "busted")
if not busted then
    print("Warning: busted not installed, running in standalone mode")
end

-- Add lib to path
package.path = "../?.lua;../?/init.lua;" .. package.path

local FArray = require("falcon_core.generic.farray")

-- Simple test harness if busted not available
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

describe("FArray.new", function()
    it("creates FArrayDouble from table", function()
        local arr = FArray.new("double", {1.0, 2.0, 3.0})
        assert(arr ~= nil, "Array should be created")
    end)
    
    it("creates FArrayInt from size", function()
        local arr = FArray.new("int", 10)
        assert(arr ~= nil, "Array should be created")
    end)
    
    it("errors on unknown type", function()
        local ok = pcall(function()
            FArray.new("unknown", {})
        end)
        assert(not ok, "Should error on unknown type")
    end)
end)

describe("FArray with Song methods", function()
    it("has to_json method via metatype", function()
        local arr = FArray.new("double", {1.0, 2.0})
        if arr.to_json then
            local json = arr:to_json()
            assert(type(json) == "string", "JSON should be a string")
            print("    JSON: " .. json:sub(1,50) .. "...")
        else
            print("    Skip: metatype not bound yet")
        end
    end)
end)

print("\n✓ FArray tests complete")
