-- tests/test_luaonic_refinements.lua
-- Verification script for new Lua-onic features

local falcon_core = require("falcon_core")
local Quantity = falcon_core.math.Quantity
local Connections = falcon_core.instrument_interfaces.Connections
local MeasuredArray = falcon_core.math.arrays.MeasuredArray

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

describe("Quantity Refinements", function()
    it("supports operator overloading (smoke test)", function()
        local q = Quantity.new(1.0, "mV")
        assert(q ~= nil, "Quantity should not be nil")
        -- For CData, the metatable is protected. We can just test addition directly.
        local ok, res = pcall(function() return q + q end)
        assert(ok, "__add operator should work: " .. tostring(res))
        assert(res ~= nil, "Result of addition should not be nil")
    end)
    
    it("can be created with string-based units", function()
        local q = Quantity.new(50.0, "mV")
        assert(q ~= nil, "Quantity should be created")
        assert(tostring(q):find("50"), "JSON should contain value")
    end)
end)

describe("Connections Refinements", function()
    it("supports table-based constructor", function()
        local conn = Connections.new({"B1", "B2", "P1"})
        assert(conn ~= nil, "Connections should be created")
        assert(#conn == 3, "Size should be 3")
    end)
    
    it("supports iteration", function()
        local conn = Connections.new({"G1", "G2"})
        local count = 0
        for i, handle in conn:items() do
            count = count + 1
        end
        assert(count == 2, "Should iterate 2 times")
    end)
end)

describe("MeasuredArray Refinements", function()
    it("supports indexing and length", function()
        local arr = MeasuredArray.new({1.0, 2.0, 3.0})
        assert(arr ~= nil, "MeasuredArray should be created")
        assert(#arr == 3, "Length should be 3")
        assert(arr[1] == 1.0, "Index 1 should be 1.0")
        assert(arr[2] == 2.0, "Index 2 should be 2.0")
    end)
end)

print("\n✓ Lua-onic refinement verification complete")
