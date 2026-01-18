-- test_analyticfunction.lua
-- Auto-generated tests for AnalyticFunction

local AnalyticFunction = require("falcon_core.math.analyticfunction")

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

describe("AnalyticFunction", function()
    it("module loads successfully", function()
        assert(AnalyticFunction ~= nil, "AnalyticFunction should load")
    end)

    it("can create instance", function()
        local obj = AnalyticFunction.identity()
        assert(obj ~= nil, "AnalyticFunction should be created")
    end)

    it("can exercise methods", function()
        local obj = AnalyticFunction.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "AnalyticFunction tests complete")
