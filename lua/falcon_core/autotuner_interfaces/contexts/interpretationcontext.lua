-- interpretationcontext.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local InterpretationContext = {}

song.register("InterpretationContext", {
    methods = {
        independent_variables = lib.InterpretationContext_independent_variables,
        dependent_variables = lib.InterpretationContext_dependent_variables,
        unit = lib.InterpretationContext_unit,
        dimension = lib.InterpretationContext_dimension,
        add_dependent_variable = lib.InterpretationContext_add_dependent_variable,
        replace_dependent_variable = lib.InterpretationContext_replace_dependent_variable,
    }
}, InterpretationContext)

return InterpretationContext
