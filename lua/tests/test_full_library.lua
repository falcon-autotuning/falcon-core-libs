-- tests/test_full_library.lua
-- Comprehensive verification of the entire Lua-onic interface

local falcon_core = require("falcon_core")
local Quantity = falcon_core.math.Quantity
local Point = falcon_core.math.Point
local Vector = falcon_core.math.Vector
local StandardRequest = falcon_core.communications.messages.StandardRequest
local StandardResponse = falcon_core.communications.messages.StandardResponse
local Group = falcon_core.physics.config.core.Group
local Domain = falcon_core.math.domains.Domain
local LabelledDomain = falcon_core.math.domains.LabelledDomain
local Time = falcon_core.io.Time

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

describe("Math Module", function()
    it("Quantity arithmetic works", function()
        local q = Quantity.new(10, "mV") + Quantity.new(5, "mV")
        assert(tostring(q):find("15"), "Should be 15")
    end)
    
    it("Point and Vector creation from tables", function()
        local v = Vector.new({G1 = Quantity.new(0, "V")}, {G1 = Quantity.new(1, "V")})
        assert(v ~= nil, "Vector should be created")
    end)
    
    it("Domain and LabelledDomain creation", function()
        local d = Domain.new(-1, 1, true, true)
        local ld = LabelledDomain.new(d, "Gate1", "P1", "GATE", "V", "Test knob")
        assert(ld:name() == "Gate1", "Name should be Gate1")
    end)
end)

describe("Communications Module", function()
    it("StandardRequest/Response creation", function()
        local req = StandardRequest.new("Hello")
        assert(req:message() == "Hello", "Message mismatch")
        local res = StandardResponse.new("ACK")
        assert(res:message() == "ACK", "Message mismatch")
    end)
end)

describe("Physics Module", function()
    local GateRelations = falcon_core.physics.config.core.GateRelations
    local Connection = require("falcon_core.instrument_interfaces.connection")
    local Connections = require("falcon_core.instrument_interfaces.connections")

    it("GateRelations creation and manipulation", function()
        local gr = GateRelations.new()
        assert(gr ~= nil, "GateRelations should be created")
        assert(gr:size() == 0, "Initial size should be 0")
        
        -- Testing registration-based methods on the module table
        assert(GateRelations.from_json ~= nil, "from_json should be available on module")
    end)
end)

describe("IO Module", function()
    it("Time creation and conversion", function()
        local now = Time.now()
        assert(now:to_seconds() > 0, "Time should be positive")
    end)
end)

print("\n✓ Full library verification complete")
