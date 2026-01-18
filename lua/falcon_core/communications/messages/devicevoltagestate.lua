-- devicevoltagestate.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local DeviceVoltageState = {}

song.register("DeviceVoltageState", {
    methods = {
        port = lib.DeviceVoltageState_port,
        voltage = lib.DeviceVoltageState_voltage,
    }
}, DeviceVoltageState)

return DeviceVoltageState
