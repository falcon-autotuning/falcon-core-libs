-- test_devicevoltagestate.lua
-- Auto-generated tests for DeviceVoltageState

local DeviceVoltageState = require("falcon_core.TODO.devicevoltagestate")

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
        local obj = DeviceVoltageState.from_json_string()
        assert(obj ~= nil, "DeviceVoltageState should be created")
    end)
end)

print("\n✓ " .. "DeviceVoltageState tests complete")
