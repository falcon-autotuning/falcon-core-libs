-- generic/list.lua
-- Generic List<T> dispatcher - COMPLETE coverage

local cdef = require("falcon_core.ffi.cdef")

local List = {}

-- Complete type dispatch table (all 50+ C-API List variants)
List._types = {
    -- Primitives
    bool = "ListBool",
    double = "ListDouble",
    float = "ListFloat",
    int = "ListInt",
    size_t = "ListSizeT",
    string = "ListString",
    
    -- Domain types
    acquisition_context = "ListAcquisitionContext",
    channel = "ListChannel",
    connection = "ListConnection",
    connections = "ListConnections",
    control_array = "ListControlArray",
    control_array_1d = "ListControlArray1D",
    coupled_labelled_domain = "ListCoupledLabelledDomain",
    device_voltage_state = "ListDeviceVoltageState",
    discretizer = "ListDiscretizer",
    dot_gate = "ListDotGateWithNeighbors",
    farray_double = "ListFArrayDouble",
    gname = "ListGname",
    group = "ListGroup",
    impedance = "ListImpedance",
    instrument_port = "ListInstrumentPort",
    interpretation_context = "ListInterpretationContext",
    labelled_control_array = "ListLabelledControlArray",
    labelled_control_array_1d = "ListLabelledControlArray1D",
    labelled_domain = "ListLabelledDomain",
    labelled_measured_array = "ListLabelledMeasuredArray",
    labelled_measured_array_1d = "ListLabelledMeasuredArray1D",
    list_size_t = "ListListSizeT",
    map_string_bool = "ListMapStringBool",
    measurement_context = "ListMeasurementContext",
    port_transform = "ListPortTransform",
    quantity = "ListQuantity",
    waveform = "ListWaveform",
    
    -- Pair types (nested)
    pair_channel_connections = "ListPairChannelConnections",
    pair_connection_connections = "ListPairConnectionConnections",
    pair_connection_double = "ListPairConnectionDouble",
    pair_connection_float = "ListPairConnectionFloat",
    pair_connection_pair_qty_qty = "ListPairConnectionPairQuantityQuantity",
    pair_connection_quantity = "ListPairConnectionQuantity",
    pair_float_float = "ListPairFloatFloat",
    pair_gname_group = "ListPairGnameGroup",
    pair_instr_port_transform = "ListPairInstrumentPortPortTransform",
    pair_int_float = "ListPairIntFloat",
    pair_int_int = "ListPairIntInt",
    pair_ctx_double = "ListPairInterpretationContextDouble",
    pair_ctx_quantity = "ListPairInterpretationContextQuantity",
    pair_ctx_string = "ListPairInterpretationContextString",
    pair_quantity_quantity = "ListPairQuantityQuantity",
    pair_size_t_size_t = "ListPairSizeTSizeT",
    pair_string_bool = "ListPairStringBool",
    pair_string_double = "ListPairStringDouble",
    pair_string_string = "ListPairStringString",
}

function List.new(dtype)
    local ctype = List._types[dtype]
    if not ctype then
        error("Unsupported List type: " .. tostring(dtype))
    end
    
    local lib = cdef.lib
    return lib[ctype .. "_create_empty"]()
end

function List.supported_types()
    local types = {}
    for k in pairs(List._types) do
        table.insert(types, k)
    end
    table.sort(types)
    return types
end

return List
