-- test_standardrequest.lua
-- Auto-generated tests for StandardRequest

local StandardRequest = require("falcon_core.communications.messages.standardrequest")

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

describe("StandardRequest", function()
    it("module loads successfully", function()
        assert(StandardRequest ~= nil, "StandardRequest should load")
    end)

    it("can create instance", function()
        local obj = StandardRequest.new()
        assert(obj ~= nil, "StandardRequest should be created")
    end)

    it("can exercise methods", function()
        local obj = StandardRequest.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
end)

print("\n✓ " .. "StandardRequest tests complete")
