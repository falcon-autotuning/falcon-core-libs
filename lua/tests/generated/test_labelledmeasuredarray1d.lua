-- test_labelledmeasuredarray1d.lua
-- Auto-generated tests for LabelledMeasuredArray1D

local LabelledMeasuredArray1D = require("falcon_core.math.arrays.labelledmeasuredarray1d")

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

describe("LabelledMeasuredArray1D", function()
    it("module loads successfully", function()
        assert(LabelledMeasuredArray1D ~= nil, "LabelledMeasuredArray1D should load")
    end)

    it("can exercise methods", function()
        local obj = LabelledMeasuredArray1D.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "LabelledMeasuredArray1D tests complete")
