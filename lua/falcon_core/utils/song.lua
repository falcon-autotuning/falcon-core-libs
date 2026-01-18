-- song.lua
-- Centralized FFI metatype management to avoid "protected metatable" collisions
local ffi = require("ffi")

local Song = {
    _extensions = {},
    _finalized = {}
}

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

-- Register extensions for a type (methods, operators, etc.)
-- This must be called BEFORE Song.init()
function Song.register(type_name, extension, module_table)
    Song._extensions[type_name] = extension
    if module_table then
        Song._extensions[type_name].module_table = module_table
    end
end

function Song.wrap_type(lib, type_name)
    local struct_name = type_name .. "_s"
    
    -- Check if the struct type exists in FFI
    local ok, _ = pcall(function() return ffi.typeof(struct_name) end)
    if not ok then return nil end

    local methods = {}
    local mt = { __index = methods }
    
    -- 1. Add automatic Song methods
    local to_json_name = type_name .. "_to_json_string"
    if lib[to_json_name] then
        methods.to_json = function(self)
            local handle = lib[to_json_name](self)
            local str = to_lua_string(lib, handle)
            return str or tostring(ffi.cast("void*", self))
        end
        mt.__tostring = methods.to_json
    end

    local destroy_name = type_name .. "_destroy"
    if lib[destroy_name] then
        mt.__gc = function(self)
            lib[destroy_name](self)
        end
    end

    -- 2. Merge user-registered extensions
    local ext = Song._extensions[type_name]
    if ext then
        -- Merge methods
        if ext.methods then
            for k, v in pairs(ext.methods) do
                methods[k] = v
            end
        end
        -- Merge metamethods (operators, etc.)
        for k, v in pairs(ext) do
            if k:match("^__") and k ~= "__index" then
                mt[k] = v
            end
        end
        -- Handle custom __index if it's a function
        if type(ext.__index) == "function" then
            local old_index = mt.__index
            mt.__index = function(t, k)
                local res = ext.__index(t, k)
                if res ~= nil then return res end
                return old_index[k]
            end
        end
    end

    -- 3. Apply metatype
    local mt_ok, mt_err = pcall(function() ffi.metatype(struct_name, mt) end)
    if not mt_ok then
        -- If it failed, log it unless it's just already bound
        if not mt_err:find("protected metatable") then
            -- Optional: print("Warning: ffi.metatype failed for " .. struct_name .. ": " .. mt_err)
        end
    end

    -- 4. Static methods (return as a table for the module to use)
    local static = {}
    local from_json_name = type_name .. "_from_json_string"
    if lib[from_json_name] then
        static.from_json = function(json_str)
            local c_str = to_c_string(lib, json_str)
            local handle = lib[from_json_name](c_str)
            return handle
        end
    end

    -- Merge user-provided static methods
    if ext and ext.static_methods then
        for k, v in pairs(ext.static_methods) do
            static[k] = v
        end
    end
    
    return static
end

function Song.init(lib)
    -- Comprehensive list of types to wrap
    local types = {
        -- Math
        "FArrayDouble", "FArrayInt", "Waveform", "Quantity", "Vector", "Point",
        "SymbolUnit", "UnitSpace", "AnalyticFunction", "IncreasingAlignment",
        "Domain", "LabelledDomain", "CoupledLabelledDomain",
        
        -- Arrays
        "MeasuredArray", "MeasuredArray1D", "ControlArray", "ControlArray1D",
        "LabelledMeasuredArray", "LabelledMeasuredArray1D",
        "LabelledControlArray", "LabelledControlArray1D",
        
        -- Instrument Interfaces
        "Channel", "Channels", "Connection", "Connections", "Impedance", "Impedances",
        "InstrumentPort", "Ports", "PortTransform", "PortTransforms",
        
        -- Physics/Config
        "Config", "Adjacency", "Group", "GateRelations", "VoltageConstraints",
        
        -- Communications
        "MeasurementRequest", "MeasurementResponse", "StandardRequest", "StandardResponse",
        "VoltageStatesResponse", "DeviceVoltageState", "DeviceVoltageStates",
        
        -- Autotuner Interfaces
        "AcquisitionContext", "MeasurementContext", "InterpretationContext",
        "Gname",
        
        -- IO
        "HDF5Data", "Time"
    }
    
    local registry = {}
    for _, t in ipairs(types) do
        local static = Song.wrap_type(lib, t)
        if static then
            registry[t] = static
            Song._finalized[t] = true
            
            -- Populate module table if it was registered
            local ext = Song._extensions[t]
            if ext and ext.module_table then
                for k, v in pairs(static) do
                    ext.module_table[k] = v
                end
            end
        end
    end
    return registry
end

return Song
