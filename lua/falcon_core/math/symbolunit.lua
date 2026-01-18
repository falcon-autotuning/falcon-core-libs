-- symbolunit.lua
-- Auto-generated wrapper for SymbolUnit
-- Generated from SymbolUnit_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local SymbolUnit = {}

-- Constructors

function SymbolUnit.from_json_string(json)
    return cdef.lib.SymbolUnit_from_json_string(json)
end

function SymbolUnit.meter()
    return cdef.lib.SymbolUnit_create_meter()
end

function SymbolUnit.kilogram()
    return cdef.lib.SymbolUnit_create_kilogram()
end


-- Methods

function SymbolUnit.copy(handle)
    return cdef.lib.SymbolUnit_copy(handle)
end

function SymbolUnit.equal(handle, other)
    return cdef.lib.SymbolUnit_equal(handle, other)
end

function SymbolUnit.not_equal(handle, other)
    return cdef.lib.SymbolUnit_not_equal(handle, other)
end

function SymbolUnit.to_json_string(handle)
    return cdef.lib.SymbolUnit_to_json_string(handle)
end

function SymbolUnit.from_json_string(handle)
    return cdef.lib.SymbolUnit_from_json_string(handle)
end


return SymbolUnit
