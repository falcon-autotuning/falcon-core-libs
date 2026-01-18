-- generic/axes.lua
-- Generic Axes<T> dispatcher - COMPLETE coverage

local cdef = require("falcon_core.ffi.cdef")

local Axes = {}

-- Complete type dispatch table (all 13 C-API Axes variants)
Axes._types = {
    control_array = "AxesControlArray",
    control_array_1d = "AxesControlArray1D",
    coupled_labelled_domain = "AxesCoupledLabelledDomain",
    discretizer = "AxesDiscretizer",
    double = "AxesDouble",
    instrument_port = "AxesInstrumentPort",
    int = "AxesInt",
    labelled_control_array = "AxesLabelledControlArray",
    labelled_control_array_1d = "AxesLabelledControlArray1D",
    labelled_measured_array = "AxesLabelledMeasuredArray",
    labelled_measured_array_1d = "AxesLabelledMeasuredArray1D",
    map_string_bool = "AxesMapStringBool",
    measurement_context = "AxesMeasurementContext",
}

function Axes.new(dtype)
    local ctype = Axes._types[dtype]
    if not ctype then
        error("Unsupported Axes type: " .. tostring(dtype))
    end
    
    local lib = cdef.lib
    return lib[ctype .. "_create_empty"]()
end

function Axes.supported_types()
    local types = {}
    for k in pairs(Axes._types) do
        table.insert(types, k)
    end
    table.sort(types)
    return types
end

return Axes
