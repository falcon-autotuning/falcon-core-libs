-- porttransforms.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local PortTransforms = {}

function PortTransforms.new(list)
    local ListTransform = require("falcon_core.generic.list").new("port_transform")
    for _, t in ipairs(list or {}) do
        lib.ListPortTransform_push_back(ListTransform, t)
    end
    local handle = lib.PortTransforms_create(ListTransform)
    lib.ListPortTransform_destroy(ListTransform)
    return handle
end

song.register("PortTransforms", {
    methods = {
        size = function(t) return tonumber(lib.PortTransforms_size(t)) end,
        at = lib.PortTransforms_at,
        equal = lib.PortTransforms_equal,
    }
}, PortTransforms)

return PortTransforms
