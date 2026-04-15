-- memory.lua
-- Memory management utilities for falcon-core handles

local M = {}

-- Track all created handles for debugging
if os.getenv("FALCON_DEBUG_MEMORY") then
    M._active_handles = setmetatable({}, {__mode = "k"})
    
    function M.track(handle, type_name)
        M._active_handles[handle] = {
            type = type_name,
            created_at = os.time()
        }
        return handle
    end
    
    function M.report()
        local count = 0
        for handle, info in pairs(M._active_handles) do
            count = count + 1
            print(string.format("Leaked: %s (age: %ds)", info.type, os.time() - info.created_at))
        end
        return count
    end
else
    -- No-op in production
    function M.track(handle) return handle end
    function M.report() return 0 end
end

return M
