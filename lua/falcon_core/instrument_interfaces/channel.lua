-- channel.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Channel = {}

function Channel.new(name)
    local s = lib.String_wrap(name)
    local handle = lib.Channel_create(s)
    lib.String_destroy(s)
    return handle
end

song.register("Channel", {
    methods = {
        name = function(self)
            local h = lib.Channel_name(self)
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
        equal = lib.Channel_equal,
    }
}, Channel)

return Channel
