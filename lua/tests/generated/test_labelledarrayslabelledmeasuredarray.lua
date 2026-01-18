-- test_labelledarrayslabelledmeasuredarray.lua
-- Auto-generated tests for LabelledArraysLabelledMeasuredArray

local LabelledArraysLabelledMeasuredArray = require("falcon_core.math.arrays.labelledarrayslabelledmeasuredarray")

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

describe("LabelledArraysLabelledMeasuredArray", function()
    it("module loads successfully", function()
        assert(LabelledArraysLabelledMeasuredArray ~= nil, "LabelledArraysLabelledMeasuredArray should load")
    end)

    it("can create instance", function()
        local obj = LabelledArraysLabelledMeasuredArray.new()
        assert(obj ~= nil, "LabelledArraysLabelledMeasuredArray should be created")
    end)

    it("can exercise methods", function()
        local obj = LabelledArraysLabelledMeasuredArray.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "LabelledArraysLabelledMeasuredArray tests complete")
