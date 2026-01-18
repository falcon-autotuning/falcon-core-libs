-- interpretationcontainerstring.lua
-- Auto-generated wrapper for InterpretationContainerString
-- Generated from InterpretationContainerString_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local InterpretationContainerString = {}

-- Constructors

function InterpretationContainerString.new(contextDoubleMap)
    return cdef.lib.InterpretationContainerString_create(contextDoubleMap)
end

function InterpretationContainerString.from_json_string(json)
    return cdef.lib.InterpretationContainerString_from_json_string(json)
end


-- Methods

function InterpretationContainerString.create(handle)
    return cdef.lib.InterpretationContainerString_create(handle)
end

function InterpretationContainerString.copy(handle)
    return cdef.lib.InterpretationContainerString_copy(handle)
end

function InterpretationContainerString.size(handle)
    return cdef.lib.InterpretationContainerString_size(handle)
end

function InterpretationContainerString.empty(handle)
    return cdef.lib.InterpretationContainerString_empty(handle)
end

function InterpretationContainerString.values(handle)
    return cdef.lib.InterpretationContainerString_values(handle)
end


return InterpretationContainerString
