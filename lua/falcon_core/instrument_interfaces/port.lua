-- port.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Port = {}

function Port.new(name)
    local s = lib.String_wrap(name)
    local handle = lib.InstrumentPort_create_port(s, nil, nil, nil, nil)
    lib.String_destroy(s)
    return handle
end

song.register("InstrumentPort", {
    methods = {
        name = function(self)
            local h = lib.InstrumentPort_default_name(self)
            if h == nil then return nil end
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
        equal = lib.InstrumentPort_equal,
        is_knob = lib.InstrumentPort_is_knob,
        is_meter = lib.InstrumentPort_is_meter,
        is_port = lib.InstrumentPort_is_port,
    }
}, Port)

return Port
