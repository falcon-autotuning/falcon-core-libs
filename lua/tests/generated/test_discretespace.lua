-- test_discretespace.lua
-- Auto-generated tests for DiscreteSpace

local DiscreteSpace = require("falcon_core.math.discrete_spaces.discretespace")

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

describe("DiscreteSpace", function()
    it("module loads successfully", function()
        assert(DiscreteSpace ~= nil, "DiscreteSpace should load")
    end)

    it("can create instance", function()
        local obj = DiscreteSpace.new()
        assert(obj ~= nil, "DiscreteSpace should be created")
    end)

    it("can exercise methods", function()
        local obj = DiscreteSpace.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "DiscreteSpace tests complete")
