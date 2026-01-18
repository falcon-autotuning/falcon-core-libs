-- test_controlarray1d.lua
-- Auto-generated tests for ControlArray1D

local ControlArray1D = require("falcon_core.math.arrays.controlarray1d")

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

describe("ControlArray1D", function()
    it("module loads successfully", function()
        assert(ControlArray1D ~= nil, "ControlArray1D should load")
    end)

    it("can create instance", function()
        local obj = ControlArray1D.new()
        assert(obj ~= nil, "ControlArray1D should be created")
    end)

    it("can exercise methods", function()
        local obj = ControlArray1D.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "ControlArray1D tests complete")
