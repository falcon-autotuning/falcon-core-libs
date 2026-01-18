-- tests/test_centralization.lua
-- Verify that centralized Song registration works correctly

local falcon_core = require("falcon_core")
local Quantity = falcon_core.math.Quantity
local Connections = falcon_core.instrument_interfaces.Connections
local Point = falcon_core.math.Point
local Vector = falcon_core.math.Vector

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

describe("Centralized Registration", function()
    it("preserves Quantity operator overloading", function()
        local q1 = Quantity.new(50.0, "mV")
        local q2 = Quantity.new(10.0, "mV")
        local total = q1 + q2
        assert(total ~= nil, "Addition should work")
        assert(tostring(total):find("60"), "Sum should be 60")
    end)
    
    it("supports Point table constructor", function()
        local q = Quantity.new(1.0, "mV")
        local p = Point.new({G1 = q, G2 = q})
        assert(p ~= nil, "Point should be created")
        assert(p:size() == 2, "Size should be 2")
    end)
    
    it("supports Vector table constructor", function()
        local q1 = Quantity.new(0, "mV")
        local q2 = Quantity.new(10, "mV")
        local v = Vector.new({G1 = q1}, {G1 = q2})
        assert(v ~= nil, "Vector should be created")
        assert(v:start_quantities() ~= nil, "Should have start quantities")
    end)
    
    it("preserves Connections iteration", function()
        local gates = Connections.new({"B1", "B2"})
        local count = 0
        for i, gate in gates:items() do
            count = count + 1
        end
        assert(count == 2, "Should iterate 2 times")
    end)
end)

print("\n✓ Centralization verification complete")
