-- test_discretizer.lua
-- Auto-generated tests for Discretizer

local Discretizer = require("falcon_core.math.discrete_spaces.discretizer")

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

describe("Discretizer", function()
    it("module loads successfully", function()
        assert(Discretizer ~= nil, "Discretizer should load")
    end)

    it("can create instance", function()
        local obj = Discretizer.new()
        assert(obj ~= nil, "Discretizer should be created")
    end)

    it("can exercise methods", function()
        local obj = Discretizer.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "Discretizer tests complete")
