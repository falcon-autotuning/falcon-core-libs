-- standardresponse.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local StandardResponse = {}
function StandardResponse.new(message)
    local s = lib.String_wrap(message or "")
    local handle = lib.StandardResponse_create(s)
    lib.String_destroy(s)
    return handle
end
song.register("StandardResponse", {
    methods = {
        message = function(self)
            local h = lib.StandardResponse_message(self)
            if h == nil then return "" end
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
    }
}, StandardResponse)
return StandardResponse
