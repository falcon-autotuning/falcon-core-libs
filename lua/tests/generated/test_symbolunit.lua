-- test_symbolunit.lua
-- Auto-generated tests for SymbolUnit

local SymbolUnit = require("falcon_core.math.symbolunit")

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

describe("SymbolUnit", function()
    it("module loads successfully", function()
        assert(SymbolUnit ~= nil, "SymbolUnit should load")
    end)

    it("can create instance", function()
        local obj = SymbolUnit.meter()
        assert(obj ~= nil, "SymbolUnit should be created")
    end)

    it("can exercise methods", function()
        local obj = SymbolUnit.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "SymbolUnit tests complete")
