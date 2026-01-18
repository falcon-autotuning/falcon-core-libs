#!/usr/bin/env luajit
-- run_tests.lua
-- Test runner with coverage tracking

local has_luacov = pcall(require, "luacov")
if has_luacov then
    print("✓ Coverage tracking enabled")
else
    print("⚠ luacov not installed, running without coverage")
    print("  Install with: luarocks install luacov")
end

-- Set package path to find modules from project root
local orig_path = package.path
package.path = "?.lua;?/init.lua;" .. package.path

-- Discover and run all tests
local test_dir = "tests/unit/"
local handle = io.popen("ls " .. test_dir .. "test_*.lua")
local tests = handle:read("*a")
handle:close()

local passed = 0
local failed = 0

for test_file in tests:gmatch("[^\n]+") do
    print("\n" .. string.rep("=", 60))
    print("Running: " .. test_file)
    print(string.rep("=", 60))
    
    local ok, err = pcall(dofile, test_file)
    if ok then
        passed = passed + 1
    else
        failed = failed + 1
        print("✗ FAILED: " .. tostring(err))
    end
end

print("\n" .. string.rep("=", 60))
print(string.format("Results: %d passed, %d failed", passed, failed))
print(string.rep("=", 60))

if has_luacov then
    print("\nGenerating coverage report...")
    os.execute("luacov")
    print("Coverage report: tests/coverage/luacov.report.out")
end

os.exit(failed == 0 and 0 or 1)
