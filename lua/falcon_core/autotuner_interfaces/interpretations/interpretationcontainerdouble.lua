-- interpretationcontainerdouble.lua
-- Auto-generated wrapper for InterpretationContainerDouble
-- Generated from InterpretationContainerDouble_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local InterpretationContainerDouble = {}

-- Constructors

function InterpretationContainerDouble.new(contextDoubleMap)
    return cdef.lib.InterpretationContainerDouble_create(contextDoubleMap)
end

function InterpretationContainerDouble.from_json_string(json)
    return cdef.lib.InterpretationContainerDouble_from_json_string(json)
end


-- Methods

function InterpretationContainerDouble.create(handle)
    return cdef.lib.InterpretationContainerDouble_create(handle)
end

function InterpretationContainerDouble.copy(handle)
    return cdef.lib.InterpretationContainerDouble_copy(handle)
end

function InterpretationContainerDouble.size(handle)
    return cdef.lib.InterpretationContainerDouble_size(handle)
end

function InterpretationContainerDouble.empty(handle)
    return cdef.lib.InterpretationContainerDouble_empty(handle)
end

function InterpretationContainerDouble.values(handle)
    return cdef.lib.InterpretationContainerDouble_values(handle)
end


return InterpretationContainerDouble
