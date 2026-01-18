-- test_gname.lua
-- Auto-generated tests for Gname

local Gname = require("falcon_core.TODO.gname")

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

describe("Gname", function()
    it("module loads successfully", function()
        assert(Gname ~= nil, "Gname should load")
    end)

    it("can create instance", function()
        local obj = Gname.from_json_string()
        assert(obj ~= nil, "Gname should be created")
    end)
end)

print("\n✓ " .. "Gname tests complete")
