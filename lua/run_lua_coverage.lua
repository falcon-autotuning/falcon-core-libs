-- run_lua_coverage.lua
-- Robust coverage runner that avoids LFS and handles errors gracefully

local test_dir = "tests/generated/"
local coverage_dir = "tests/coverage/"
local lua_path = os.getenv("LUA_PATH") or ""

-- Ensure coverage dir exists
os.execute("mkdir -p " .. coverage_dir)

local function list_files(dir, pattern)
    local t = {}
    local p = io.popen("ls -1 " .. dir)
    for file in p:lines() do
        if file:match(pattern or "^test_.*%.lua$") then
            table.insert(t, {path = dir, name = file})
        end
    end
    p:close()
    return t
end

local all_tests = {}
for _, t in ipairs(list_files("tests/unit/")) do table.insert(all_tests, t) end
for _, t in ipairs(list_files("tests/generated/")) do table.insert(all_tests, t) end
table.insert(all_tests, {path = "tests/", name = "test_full_library.lua"})

print("Found " .. #all_tests .. " tests to run.")
print("========================================")

local total_passed = 0
local total_failed = 0

for i, t in ipairs(all_tests) do
    io.write(string.format("[%2d/%2d] %-45s ", i, #all_tests, t.name))
    io.flush()
    
    local cmd = string.format("export LUA_PATH='%s' && luajit -lluacov %s/%s 2>&1", lua_path, t.path, t.name)
    local f = io.popen(cmd)
    local output = f:read("*all")
    local ok, exit_type, code = f:close()
    
    if ok then
        print("✓ PASS")
        total_passed = total_passed + 1
    else
        print("✗ FAIL (" .. tostring(code) .. ")")
        print("   " .. (output:gsub("\n", "\n   "):sub(1, 150)) .. "...")
        total_failed = total_failed + 1
    end
end

print("========================================")
print(string.format("Final Results: %d passed, %d failed", total_passed, total_failed))

-- Generate final report
print("Generating Luacov report...")
os.execute("/home/daniel/.luarocks/bin/luacov")
