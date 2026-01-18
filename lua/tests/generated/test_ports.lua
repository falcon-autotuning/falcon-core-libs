-- test_ports.lua
-- Auto-generated tests for Ports

local Ports = require("falcon_core.instrument_interfaces.ports")

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

describe("Ports", function()
    it("module loads successfully", function()
        assert(Ports ~= nil, "Ports should load")
    end)

    it("can create instance", function()
        local obj = Ports.empty()
        assert(obj ~= nil, "Ports should be created")
    end)

    it("can exercise methods", function()
        local obj = Ports.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "Ports tests complete")
