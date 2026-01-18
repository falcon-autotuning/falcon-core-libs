-- generic/farray.lua
-- Generic FArray<T> dispatcher - COMPLETE coverage

local ffi = require("ffi")
local cdef = require("falcon_core.ffi.cdef")

local FArray = {}

-- Complete type dispatch table (all C-API variants)
FArray._types = {
    double = "FArrayDouble",
    int = "FArrayInt",
}

-- Create new FArray of specified type
function FArray.new(dtype, data)
    local ctype = FArray._types[dtype]
    if not ctype then
        error("Unsupported FArray type: " ..  tostring(dtype) .. ". Supported: " .. table.concat(vim.tbl_keys(FArray._types), ", "))
    end
    
    local lib = cdef.lib
    
    -- Create array based on input
    if type(data) == "table" then
        -- From Lua table
        local len = #data
        local shape = ffi.new("size_t[1]", len)
        
        -- Convert table to C array
        local c_data
        if dtype == "double" then
            c_data = ffi.new("double[?]", len, data)
        elseif dtype == "int" then
            c_data = ffi.new("int[?]", len, data)
        else
            error("Unsupported FArray type for table construction: " .. dtype)
        end
        
        return lib[ctype .. "_from_data"](c_data, shape, 1)
    elseif type(data) == "number" then
        -- Create zeros
        local shape = ffi.new("size_t[1]", data)
        return lib[ctype .. "_create_zeros"](shape, 1)
    else
        error("Invalid data type for FArray.new: expected table or number")
    end
end

-- Get type name from handle (for debugging)
function FArray.typeof(handle)
    for lua_type, c_type in pairs(FArray._types) do
        if ffi.istype(c_type .. "Handle", handle) then
            return lua_type
        end
    end
    return "unknown"
end

-- Statistics
function FArray.supported_types()
    local types = {}
    for k in pairs(FArray._types) do
        table.insert(types, k)
    end
    table.sort(types)
    return types
end

return FArray
