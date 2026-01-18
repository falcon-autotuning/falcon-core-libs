-- test_measurementrequest.lua
-- Auto-generated tests for MeasurementRequest

local MeasurementRequest = require("falcon_core.TODO.measurementrequest")

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
        local obj = MeasurementRequest.from_json_string()
        assert(obj ~= nil, "MeasurementRequest should be created")
    end)
end)

print("\n✓ " .. "MeasurementRequest tests complete")
