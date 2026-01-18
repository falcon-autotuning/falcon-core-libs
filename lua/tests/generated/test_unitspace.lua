-- test_unitspace.lua
-- Auto-generated tests for UnitSpace

local UnitSpace = require("falcon_core.TODO.unitspace")

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

describe("UnitSpace", function()
    it("module loads successfully", function()
        assert(UnitSpace ~= nil, "UnitSpace should load")
    end)

    it("can create instance", function()
        local obj = UnitSpace.from_json_string()
        assert(obj ~= nil, "UnitSpace should be created")
    end)
end)

print("\n✓ " .. "UnitSpace tests complete")
