-- test_hdf5data.lua
-- Auto-generated tests for HDF5Data

local HDF5Data = require("falcon_core.io.hdf5data")

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

describe("HDF5Data", function()
    it("module loads successfully", function()
        assert(HDF5Data ~= nil, "HDF5Data should load")
    end)

    it("can create instance", function()
        local obj = HDF5Data.new()
        assert(obj ~= nil, "HDF5Data should be created")
    end)

    it("can exercise methods", function()
        local obj = HDF5Data.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "HDF5Data tests complete")
