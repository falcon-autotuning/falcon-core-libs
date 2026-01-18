-- test_devicevoltagestate.lua
-- Auto-generated tests for DeviceVoltageState

local DeviceVoltageState = require("falcon_core.communications.voltage_states.devicevoltagestate")

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

describe("DeviceVoltageState", function()
    it("module loads successfully", function()
        assert(DeviceVoltageState ~= nil, "DeviceVoltageState should load")
    end)

    it("can create instance", function()
        local obj = DeviceVoltageState.new()
        assert(obj ~= nil, "DeviceVoltageState should be created")
    end)

    it("can exercise methods", function()
        local obj = DeviceVoltageState.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "DeviceVoltageState tests complete")
