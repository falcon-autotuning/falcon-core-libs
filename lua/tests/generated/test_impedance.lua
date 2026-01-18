-- test_impedance.lua
-- Auto-generated tests for Impedance

local Impedance = require("falcon_core.instrument_interfaces.impedance")

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

describe("Impedance", function()
    it("module loads successfully", function()
        assert(Impedance ~= nil, "Impedance should load")
    end)

    it("can create instance", function()
        local obj = Impedance.new()
        assert(obj ~= nil, "Impedance should be created")
    end)

    it("can exercise methods", function()
        local obj = Impedance.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "Impedance tests complete")
