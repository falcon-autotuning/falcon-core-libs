-- generic/pair.lua
-- Generic Pair<T,U> dispatcher - COMPLETE coverage

local cdef = require("falcon_core.ffi.cdef")

local Pair = {}

-- Complete type dispatch table (all 21 C-API Pair variants)
Pair._types = {
    channel_connections = "PairChannelConnections",
    connection_connection = "PairConnectionConnection",
    connection_connections = "PairConnectionConnections",
    connection_double = "PairConnectionDouble",
    connection_float = "PairConnectionFloat",
    connection_pair_qty_qty = "PairConnectionPairQuantityQuantity",
    connection_quantity = "PairConnectionQuantity",
    double_double = "PairDoubleDouble",
    float_float = "PairFloatFloat",
    gname_group = "PairGnameGroup",
    instrument_port_transform = "PairInstrumentPortPortTransform",
    int_float = "PairIntFloat",
    int_int = "PairIntInt",
    interpretation_context_double = "PairInterpretationContextDouble",
    interpretation_context_quantity = "PairInterpretationContextQuantity",
    interpretation_context_string = "PairInterpretationContextString",
    measurement_response_request = "PairMeasurementResponseMeasurementRequest",
    quantity_quantity = "PairQuantityQuantity",
    size_t_size_t = "PairSizeTSizeT",
    string_bool = "PairStringBool",
    string_double = "PairStringDouble",
    string_string = "PairStringString",
}

function Pair.new(pair_type, first_val, second_val)
    local ctype = Pair._types[pair_type]
    if not ctype then
        error("Unsupported Pair type: " .. tostring(pair_type))
    end
    
    local lib = cdef.lib
    return lib[ctype .. "_create"](first_val, second_val)
end

function Pair.supported_types()
    local types = {}
    for k in pairs(Pair._types) do
        table.insert(types, k)
    end
    table.sort(types)
    return types
end

return Pair
