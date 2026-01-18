-- test_loader.lua
-- Auto-generated tests for Loader

local Loader = require("falcon_core.TODO.loader")

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

describe("Loader", function()
    it("module loads successfully", function()
        assert(Loader ~= nil, "Loader should load")
    end)

    it("can create instance", function()
        local obj = Loader.new()
        assert(obj ~= nil, "Loader should be created")
    end)
end)

print("\n✓ " .. "Loader tests complete")
