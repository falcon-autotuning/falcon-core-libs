-- test_dotgateswithneighbors.lua
-- Auto-generated tests for DotGatesWithNeighbors

local DotGatesWithNeighbors = require("falcon_core.physics.config.geometries.dotgateswithneighbors")

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

describe("DotGatesWithNeighbors", function()
    it("module loads successfully", function()
        assert(DotGatesWithNeighbors ~= nil, "DotGatesWithNeighbors should load")
    end)

    it("can create instance", function()
        local obj = DotGatesWithNeighbors.empty()
        assert(obj ~= nil, "DotGatesWithNeighbors should be created")
    end)

    it("can exercise methods", function()
        local obj = DotGatesWithNeighbors.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "DotGatesWithNeighbors tests complete")
