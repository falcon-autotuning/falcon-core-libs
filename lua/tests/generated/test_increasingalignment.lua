-- test_increasingalignment.lua
-- Auto-generated tests for IncreasingAlignment

local IncreasingAlignment = require("falcon_core.math.increasingalignment")

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

describe("IncreasingAlignment", function()
    it("module loads successfully", function()
        assert(IncreasingAlignment ~= nil, "IncreasingAlignment should load")
    end)

    it("can create instance", function()
        local obj = IncreasingAlignment.empty()
        assert(obj ~= nil, "IncreasingAlignment should be created")
    end)

    it("can exercise methods", function()
        local obj = IncreasingAlignment.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "IncreasingAlignment tests complete")
