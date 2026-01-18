-- analyticfunction.lua
-- Auto-generated wrapper for AnalyticFunction
-- Generated from AnalyticFunction_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local AnalyticFunction = {}

-- Constructors

function AnalyticFunction.from_json_string(json)
    return cdef.lib.AnalyticFunction_from_json_string(json)
end

function AnalyticFunction.identity()
    return cdef.lib.AnalyticFunction_create_identity()
end

function AnalyticFunction.constant(value)
    return cdef.lib.AnalyticFunction_create_constant(value)
end


-- Methods

function AnalyticFunction.copy(handle)
    return cdef.lib.AnalyticFunction_copy(handle)
end

function AnalyticFunction.to_json_string(handle)
    return cdef.lib.AnalyticFunction_to_json_string(handle)
end

function AnalyticFunction.from_json_string(handle)
    return cdef.lib.AnalyticFunction_from_json_string(handle)
end

function AnalyticFunction.create_identity(handle)
    return cdef.lib.AnalyticFunction_create_identity(handle)
end

function AnalyticFunction.create_constant(handle)
    return cdef.lib.AnalyticFunction_create_constant(handle)
end


return AnalyticFunction
