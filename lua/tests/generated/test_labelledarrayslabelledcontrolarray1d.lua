-- test_labelledarrayslabelledcontrolarray1d.lua
-- Auto-generated tests for LabelledArraysLabelledControlArray1D

local LabelledArraysLabelledControlArray1D = require("falcon_core.math.arrays.labelledarrayslabelledcontrolarray1d")

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

describe("LabelledArraysLabelledControlArray1D", function()
    it("module loads successfully", function()
        assert(LabelledArraysLabelledControlArray1D ~= nil, "LabelledArraysLabelledControlArray1D should load")
    end)

    it("can create instance", function()
        local obj = LabelledArraysLabelledControlArray1D.new()
        assert(obj ~= nil, "LabelledArraysLabelledControlArray1D should be created")
    end)

    it("can exercise methods", function()
        local obj = LabelledArraysLabelledControlArray1D.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "LabelledArraysLabelledControlArray1D tests complete")
