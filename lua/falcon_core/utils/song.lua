-- song.lua
-- Lua-onic wrappers for Song-derived C-API objects
local ffi = require("ffi")

local Song = {}

-- Utility to convert C StringHandle to Lua string and cleanup
local function to_lua_string(lib, handle)
    if handle == nil then return nil end
    local lua_str = ffi.string(handle.raw, handle.length)
    lib.String_destroy(handle)
    return lua_str
end

-- Utility to convert Lua string to C StringHandle
local function to_c_string(lib, str)
    if str == nil then return nil end
    return lib.String_wrap(str)
end

function Song.wrap_type(lib, type_name)
    local struct_name = type_name .. "_s"
    
    -- Check if the struct type exists in FFI
    local ok, _ = pcall(function() return ffi.typeof(struct_name) end)
    if not ok then return nil end

    local methods = {}
    
    -- Add to_json if it exists
    local to_json_name = type_name .. "_to_json_string"
    if lib[to_json_name] then
        methods.to_json = function(self)
            local handle = lib[to_json_name](self)
            return to_lua_string(lib, handle)
        end
        methods.__tostring = methods.to_json
    end

    -- Add destroy if it exists for GC
    local destroy_name = type_name .. "_destroy"
    local gc_fn = nil
    if lib[destroy_name] then
        gc_fn = function(self)
            lib[destroy_name](self)
        end
    end

    -- Create metatype (bind to the struct itself, which affects pointers to it)
    local mt = {
        __index = methods,
        __gc = gc_fn
    }
    
    ffi.metatype(struct_name, mt)

    -- Static methods (e.g. from_json)
    local static = {}
    local from_json_name = type_name .. "_from_json_string"
    if lib[from_json_name] then
        static.from_json = function(json_str)
            local c_str = to_c_string(lib, json_str)
            local handle = lib[from_json_name](c_str)
            -- Note: String_wrap creates a handle but we don't have a way to easily 
            -- track its destruction here without more complex logic. 
            -- For now, we assume standard usage.
            return handle
        end
    end

    return static
end

function Song.init(lib)
    -- We'll want to iterate through common types and wrap them
    local types = {
        "FArrayDouble", "FArrayInt", "Waveform", "Quantity", "Config", "Vector", "Point",
        "MeasuredArray", "MeasuredArray1D", "ControlArray", "ControlArray1D",
        "LabelledMeasuredArray", "LabelledMeasuredArray1D",
        "MeasurementRequest", "MeasurementResponse", "VoltageConstraints",
        "AcquisitionContext", "SymbolUnit", "InstrumentPort"
    }
    
    local registry = {}
    for _, t in ipairs(types) do
        local static = Song.wrap_type(lib, t)
        if static then
            registry[t] = static
        end
    end
    return registry
end

return Song
