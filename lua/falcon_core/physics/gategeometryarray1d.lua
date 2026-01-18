-- gategeometryarray1d.lua
-- Auto-generated wrapper for GateGeometryArray1D
-- Generated from GateGeometryArray1D_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local GateGeometryArray1D = {}

-- Constructors


-- Methods

function GateGeometryArray1D.ohmics(handle)
    return cdef.lib.GateGeometryArray1D_ohmics(handle)
end


return GateGeometryArray1D
