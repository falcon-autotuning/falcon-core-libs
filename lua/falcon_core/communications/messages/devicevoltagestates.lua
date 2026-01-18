-- devicevoltagestates.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local DeviceVoltageStates = {}

song.register("DeviceVoltageStates", {
    methods = {
        size = function(t) return tonumber(lib.DeviceVoltageStates_size(t)) end,
        at = lib.DeviceVoltageStates_at,
    }
}, DeviceVoltageStates)

return DeviceVoltageStates
