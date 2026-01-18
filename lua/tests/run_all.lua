-- tests/run_all.lua
require("luacov")

local function list_files(dir, pattern)
    local t = {}
    local p = io.popen("ls -1 " .. dir)
    if not p then return t end
    for file in p:lines() do
        if file:match(pattern or "^test_.*%.lua$") then
            table.insert(t, dir .. file)
        end
    end
    p:close()
    return t
end

local all_test_files = {}
for _, f in ipairs(list_files("tests/unit/")) do table.insert(all_test_files, f) end
for _, f in ipairs(list_files("tests/generated/")) do table.insert(all_test_files, f) end
table.insert(all_test_files, "tests/test_full_library.lua")

print("Running " .. #all_test_files .. " tests in a single process...")

local passed = 0
local failed = 0

for i, file in ipairs(all_test_files) do
    print(string.format("[%d/%d] Loading %s", i, #all_test_files, file))
    local chunk, err = loadfile(file)
    if not chunk then
        print("  ✗ Error loading file: " .. tostring(err))
        failed = failed + 1
    else
        local ok, run_err = pcall(chunk)
        if ok then
            passed = passed + 1
        else
            print("  ✗ Error running file: " .. tostring(run_err))
            failed = failed + 1
        end
    end
end

print("\n========================================")
print(string.format("Final Results: %d passed, %d failed", passed, failed))
if failed > 0 then
    os.exit(1)
end
