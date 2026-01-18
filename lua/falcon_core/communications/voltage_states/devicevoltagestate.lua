-- devicevoltagestate.lua
-- Auto-generated wrapper for DeviceVoltageState
-- Generated from DeviceVoltageState_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local DeviceVoltageState = {}

-- Constructors

function DeviceVoltageState.from_json_string(json)
    return cdef.lib.DeviceVoltageState_from_json_string(json)
end


-- Methods

function DeviceVoltageState.connection(handle)
    return cdef.lib.DeviceVoltageState_connection(handle)
end

function DeviceVoltageState.voltage(handle)
    return cdef.lib.DeviceVoltageState_voltage(handle)
end

function DeviceVoltageState.value(handle)
    return cdef.lib.DeviceVoltageState_value(handle)
end

function DeviceVoltageState.unit(handle)
    return cdef.lib.DeviceVoltageState_unit(handle)
end

function DeviceVoltageState.to_json_string(handle)
    return cdef.lib.DeviceVoltageState_to_json_string(handle)
end


return DeviceVoltageState
