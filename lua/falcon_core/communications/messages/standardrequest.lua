-- standardrequest.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local StandardRequest = {}
function StandardRequest.new(message)
    local s = lib.String_wrap(message or "")
    local handle = lib.StandardRequest_create(s)
    lib.String_destroy(s)
    return handle
end
song.register("StandardRequest", {
    methods = {
        message = function(self)
            local h = lib.StandardRequest_message(self)
            if h == nil then return "" end
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
    }
}, StandardRequest)
return StandardRequest
