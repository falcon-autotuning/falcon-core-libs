-- increasingalignment.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local IncreasingAlignment = {}

function IncreasingAlignment.new(alignment)
    return lib.IncreasingAlignment_create(alignment or 0)
end

song.register("IncreasingAlignment", {
    methods = {
        alignment = lib.IncreasingAlignment_alignment,
    }
}, IncreasingAlignment)

return IncreasingAlignment
