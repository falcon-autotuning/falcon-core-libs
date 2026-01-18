-- voltagestatesresponse.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local VoltageStatesResponse = {}

song.register("VoltageStatesResponse", {
    methods = {
        states = lib.VoltageStatesResponse_states,
        message = function(self)
            local h = lib.VoltageStatesResponse_message(self)
            if h == nil then return "" end
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
    }
}, VoltageStatesResponse)

return VoltageStatesResponse
