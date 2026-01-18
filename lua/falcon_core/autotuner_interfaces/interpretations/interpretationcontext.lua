-- interpretationcontext.lua
-- Auto-generated wrapper for InterpretationContext
-- Generated from InterpretationContext_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local InterpretationContext = {}

-- Constructors


-- Methods

function InterpretationContext.unit(handle)
    return cdef.lib.InterpretationContext_unit(handle)
end

function InterpretationContext.dimension(handle)
    return cdef.lib.InterpretationContext_dimension(handle)
end


return InterpretationContext
