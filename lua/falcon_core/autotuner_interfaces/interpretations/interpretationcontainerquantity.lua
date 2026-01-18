-- interpretationcontainerquantity.lua
-- Auto-generated wrapper for InterpretationContainerQuantity
-- Generated from InterpretationContainerQuantity_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local InterpretationContainerQuantity = {}

-- Constructors

function InterpretationContainerQuantity.new(contextDoubleMap)
    return cdef.lib.InterpretationContainerQuantity_create(contextDoubleMap)
end

function InterpretationContainerQuantity.from_json_string(json)
    return cdef.lib.InterpretationContainerQuantity_from_json_string(json)
end


-- Methods

function InterpretationContainerQuantity.create(handle)
    return cdef.lib.InterpretationContainerQuantity_create(handle)
end

function InterpretationContainerQuantity.copy(handle)
    return cdef.lib.InterpretationContainerQuantity_copy(handle)
end

function InterpretationContainerQuantity.size(handle)
    return cdef.lib.InterpretationContainerQuantity_size(handle)
end

function InterpretationContainerQuantity.empty(handle)
    return cdef.lib.InterpretationContainerQuantity_empty(handle)
end

function InterpretationContainerQuantity.values(handle)
    return cdef.lib.InterpretationContainerQuantity_values(handle)
end


return InterpretationContainerQuantity
