-- tests/unit/test_math.lua
-- Tests for math module (Quantity, Vector, Point)

local math_mod = require("falcon_core.math")
local Quantity = math_mod.Quantity
local Vector = math_mod.Vector
local Point = math_mod.Point

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

describe("Quantity", function()
    it("can be created (basic smoke test)", function()
        -- Note: Full creation requires SymbolUnit setup
        -- This is a basic module load test
        assert(Quantity ~= nil, "Quantity module should load")
        assert(Quantity.add ~= nil, "Should have add method")
        assert(Quantity.multiply ~= nil, "Should have multiply method")
    end)
end)

describe("Vector", function()
    it("module loads successfully", function()
        assert(Vector ~= nil, "Vector module should load")
        assert(Vector.from_end ~= nil, "Should have from_end method")
    end)
end)

describe("Point", function()
    it("module loads successfully", function()
        assert(Point ~= nil, "Point module should load")
        assert(Point.set ~= nil, "Should have set method")
        assert(Point.get ~= nil, "Should have get method")
    end)
end)

print("\n✓ Math module tests complete")
