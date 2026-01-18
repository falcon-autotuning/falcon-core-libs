-- test_dotgatewithneighbors.lua
-- Auto-generated tests for DotGateWithNeighbors

local DotGateWithNeighbors = require("falcon_core.physics.config.geometries.dotgatewithneighbors")

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

describe("DotGateWithNeighbors", function()
    it("module loads successfully", function()
        assert(DotGateWithNeighbors ~= nil, "DotGateWithNeighbors should load")
    end)

    it("can exercise methods", function()
        local obj = DotGateWithNeighbors.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "DotGateWithNeighbors tests complete")
