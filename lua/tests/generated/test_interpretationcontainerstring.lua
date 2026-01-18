-- test_interpretationcontainerstring.lua
-- Auto-generated tests for InterpretationContainerString

local InterpretationContainerString = require("falcon_core.autotuner_interfaces.interpretations.interpretationcontainerstring")

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

describe("InterpretationContainerString", function()
    it("module loads successfully", function()
        assert(InterpretationContainerString ~= nil, "InterpretationContainerString should load")
    end)

    it("can create instance", function()
        local obj = InterpretationContainerString.new()
        assert(obj ~= nil, "InterpretationContainerString should be created")
    end)

    it("can exercise methods", function()
        local obj = InterpretationContainerString.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "InterpretationContainerString tests complete")
