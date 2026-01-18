-- tests/unit/test_arrays.lua
-- Tests for arrays module

local arrays = require("falcon_core.arrays")
local MeasuredArray = arrays.MeasuredArray
local ControlArray = arrays.ControlArray
local LabelledMeasuredArray = arrays.LabelledMeasuredArray  
local LabelledControlArray = arrays.LabelledControlArray

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

describe("MeasuredArray", function()
    it("module loads successfully", function()
        assert(MeasuredArray ~= nil, "MeasuredArray should load")
        assert(MeasuredArray.from_farray ~= nil, "Should have from_farray")
        assert(MeasuredArray.add ~= nil, "Should have arithmetic")
    end)
end)

describe("ControlArray", function()
    it("module loads successfully", function()
        assert(ControlArray ~= nil, "ControlArray should load")
        assert(ControlArray.from_farray ~= nil, "Should have from_farray")
        assert(ControlArray.gradient ~= nil, "Should have gradient")
    end)
end)

describe("LabelledMeasuredArray", function()
    it("module loads successfully", function()
        assert(LabelledMeasuredArray ~= nil, "LabelledMeasuredArray should load")
        assert(LabelledMeasuredArray.from_farray ~= nil, "Should have from_farray")
        assert(LabelledMeasuredArray.label ~= nil, "Should have label getter")
    end)
end)

describe("LabelledControlArray", function()
    it("module loads successfully", function()
        assert(LabelledControlArray ~= nil, "LabelledControlArray should load")
        assert(LabelledControlArray.from_farray ~= nil, "Should have from_farray")
        assert(LabelledControlArray.gradient ~= nil, "Should have gradient")
    end)
end)

print("\n✓ Arrays module tests complete")
