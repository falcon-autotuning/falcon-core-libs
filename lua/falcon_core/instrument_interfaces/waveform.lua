-- waveform.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Waveform = {}

function Waveform.new(space, transforms)
    return lib.Waveform_create(space, transforms)
end

song.register("Waveform", {
    methods = {
        space = lib.Waveform_space,
        transforms = lib.Waveform_transforms,
        size = function(t) return tonumber(lib.Waveform_size(t)) end,
        at = lib.Waveform_at,
        push_back = lib.Waveform_push_back,
    }
}, Waveform)

return Waveform
