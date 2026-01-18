-- analyticfunction.lua
-- Wrapper for AnalyticFunction (mathematical function for signal generation)

local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")

local AnalyticFunction = {}

-- Create from expression and labels
function AnalyticFunction.new(expression, labels)
    local ListString = require("falcon_core.generic.list").new("string")
    for _, l in ipairs(labels or {}) do
        lib.ListString_push_back(ListString, lib.String_wrap(l))
    end
    
    local s_expr = lib.String_wrap(expression)
    local handle = lib.AnalyticFunction_create(ListString, s_expr)
    
    lib.ListString_destroy(ListString)
    lib.String_destroy(s_expr)
    return handle
end

-- Create identity or constant
function AnalyticFunction.identity() return lib.AnalyticFunction_create_identity() end
function AnalyticFunction.constant(v) return lib.AnalyticFunction_create_constant(v) end

-- Register extensions for Song
song.register("AnalyticFunction", {
    methods = {
        formula = function(self)
            local h = lib.AnalyticFunction_to_json_string(self)
            if h == nil then return "" end
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
        labels = lib.AnalyticFunction_labels,
        evaluate = lib.AnalyticFunction_evaluate,
    }
})

return AnalyticFunction
