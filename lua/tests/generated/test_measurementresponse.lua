-- test_measurementresponse.lua
-- Auto-generated tests for MeasurementResponse

local MeasurementResponse = require("falcon_core.communications.messages.measurementresponse")

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

describe("MeasurementResponse", function()
    it("module loads successfully", function()
        assert(MeasurementResponse ~= nil, "MeasurementResponse should load")
    end)

    it("can exercise methods", function()
        local obj = MeasurementResponse.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "MeasurementResponse tests complete")
