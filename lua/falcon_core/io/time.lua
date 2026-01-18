-- time.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Time = {}

song.register("Time", {
    static_methods = {
        now = lib.Time_create_now,
        at = lib.Time_create_at,
    },
    methods = {
        micro_seconds_since_epoch = lib.Time_micro_seconds_since_epoch,
        time = lib.Time_time,
        to_seconds = lib.Time_time, -- Alias for time which returns seconds
        to_string = lib.Time_to_string,
    }
}, Time)

return Time
