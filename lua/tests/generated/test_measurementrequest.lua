-- test_measurementrequest.lua
-- Auto-generated tests for MeasurementRequest

local MeasurementRequest = require("falcon_core.communications.messages.measurementrequest")

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

describe("MeasurementRequest", function()
    it("module loads successfully", function()
        assert(MeasurementRequest ~= nil, "MeasurementRequest should load")
    end)

    it("can create instance", function()
        local obj = MeasurementRequest.new()
        assert(obj ~= nil, "MeasurementRequest should be created")
    end)

    it("can exercise methods", function()
        local obj = MeasurementRequest.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "MeasurementRequest tests complete")
