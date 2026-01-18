-- test_labelledarrayslabelledmeasuredarray1d.lua
-- Auto-generated tests for LabelledArraysLabelledMeasuredArray1D

local LabelledArraysLabelledMeasuredArray1D = require("falcon_core.TODO.labelledarrayslabelledmeasuredarray1d")

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

describe("LabelledArraysLabelledMeasuredArray1D", function()
    it("module loads successfully", function()
        assert(LabelledArraysLabelledMeasuredArray1D ~= nil, "LabelledArraysLabelledMeasuredArray1D should load")
    end)

    it("can create instance", function()
        local obj = LabelledArraysLabelledMeasuredArray1D.from_json_string()
        assert(obj ~= nil, "LabelledArraysLabelledMeasuredArray1D should be created")
    end)
end)

print("\n✓ " .. "LabelledArraysLabelledMeasuredArray1D tests complete")
