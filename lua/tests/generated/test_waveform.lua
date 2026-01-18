-- test_waveform.lua
-- Auto-generated tests for Waveform

local Waveform = require("falcon_core.TODO.waveform")

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

describe("Waveform", function()
    it("module loads successfully", function()
        assert(Waveform ~= nil, "Waveform should load")
    end)

    it("can create instance", function()
        local obj = Waveform.from_json_string()
        assert(obj ~= nil, "Waveform should be created")
    end)
end)

print("\n✓ " .. "Waveform tests complete")
