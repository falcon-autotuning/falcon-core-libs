-- devicevoltagestates.lua
-- Auto-generated wrapper for DeviceVoltageStates
-- Generated from DeviceVoltageStates_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local DeviceVoltageStates = {}

-- Constructors

function DeviceVoltageStates.empty()
    return cdef.lib.DeviceVoltageStates_create_empty()
end


-- Methods

function DeviceVoltageStates.create_empty(handle)
    return cdef.lib.DeviceVoltageStates_create_empty(handle)
end

function DeviceVoltageStates.to_point(handle)
    return cdef.lib.DeviceVoltageStates_to_point(handle)
end

function DeviceVoltageStates.size(handle)
    return cdef.lib.DeviceVoltageStates_size(handle)
end

function DeviceVoltageStates.empty(handle)
    return cdef.lib.DeviceVoltageStates_empty(handle)
end


return DeviceVoltageStates
