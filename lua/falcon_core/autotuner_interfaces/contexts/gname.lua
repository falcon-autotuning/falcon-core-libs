-- gname.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Gname = {}

function Gname.new(name)
    local s = lib.String_wrap(name)
    local handle = lib.Gname_create(s)
    lib.String_destroy(s)
    return handle
end

song.register("Gname", {
    methods = {
        name = function(self)
            local h = lib.Gname_name(self)
            if h == nil then return "" end
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
        equal = lib.Gname_equal,
    }
}, Gname)

return Gname
