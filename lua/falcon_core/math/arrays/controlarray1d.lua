-- controlarray1d.lua
-- Auto-generated wrapper for ControlArray1D
-- Generated from ControlArray1D_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local ControlArray1D = {}

-- Constructors

function ControlArray1D.from_json_string(json)
    return cdef.lib.ControlArray1D_from_json_string(json)
end

function ControlArray1D.from_farray(farray)
    return cdef.lib.ControlArray1D_from_farray(farray)
end


-- Methods

function ControlArray1D.copy(handle)
    return cdef.lib.ControlArray1D_copy(handle)
end

function ControlArray1D.to_json_string(handle)
    return cdef.lib.ControlArray1D_to_json_string(handle)
end

function ControlArray1D.from_json_string(handle)
    return cdef.lib.ControlArray1D_from_json_string(handle)
end

function ControlArray1D.from_farray(handle)
    return cdef.lib.ControlArray1D_from_farray(handle)
end

function ControlArray1D.is_1D(handle)
    return cdef.lib.ControlArray1D_is_1D(handle)
end


return ControlArray1D
