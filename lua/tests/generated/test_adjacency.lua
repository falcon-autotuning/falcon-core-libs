-- test_adjacency.lua
-- Auto-generated tests for Adjacency

local Adjacency = require("falcon_core.TODO.adjacency")

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

describe("Adjacency", function()
    it("module loads successfully", function()
        assert(Adjacency ~= nil, "Adjacency should load")
    end)

    it("can create instance", function()
        local obj = Adjacency.from_json_string()
        assert(obj ~= nil, "Adjacency should be created")
    end)
end)

print("\n✓ " .. "Adjacency tests complete")
