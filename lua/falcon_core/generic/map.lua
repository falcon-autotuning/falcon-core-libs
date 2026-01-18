-- generic/map.lua
-- Generic Map<K,V> dispatcher - COMPLETE coverage

local cdef = require("falcon_core.ffi.cdef")

local Map = {}

-- Complete type dispatch table (all 14 C-API Map variants)
Map._types = {
    channel_connections = "MapChannelConnections",
    connection_double = "MapConnectionDouble",
    connection_float = "MapConnectionFloat",
    connection_quantity = "MapConnectionQuantity",
    float_float = "MapFloatFloat",
    gname_group = "MapGnameGroup",
    instrument_port_transform = "MapInstrumentPortPortTransform",
    int_int = "MapIntInt",
    interpretation_context_double = "MapInterpretationContextDouble",
    interpretation_context_quantity = "MapInterpretationContextQuantity",
    interpretation_context_string = "MapInterpretationContextString",
    string_bool = "MapStringBool",
    string_double = "MapStringDouble",
    string_string = "MapStringString",
}

function Map.new(key_value_type)
    local ctype = Map._types[key_value_type]
    if not ctype then
        error("Unsupported Map type: " .. tostring(key_value_type))
    end
    
    local lib = cdef.lib
    return lib[ctype .. "_create_empty"]()
end

function Map.supported_types()
    local types = {}
    for k in pairs(Map._types) do
        table.insert(types, k)
    end
    table.sort(types)
    return types
end

return Map
