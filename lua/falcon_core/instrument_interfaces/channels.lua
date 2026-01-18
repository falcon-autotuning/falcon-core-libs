-- channels.lua
-- Wrapper for Channels (collection of signal paths)

local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")

local Channels = {}

-- Create from list of names
function Channels.new(list)
    if not list then return lib.Channels_create_empty() end
    
    local ListChannel = require("falcon_core.generic.list").new("channel")
    local Channel = require("falcon_core.instrument_interfaces.channel")
    
    for _, name in ipairs(list) do
        local chan = (type(name) == "string") and Channel.new(name) or name
        lib.ListChannel_push_back(ListChannel, chan)
    end
    
    local handle = lib.Channels_create(ListChannel)
    lib.ListChannel_destroy(ListChannel)
    return handle
end

-- Register extensions for Song
song.register("Channels", {
    __len = function(t) return tonumber(lib.Channels_size(t)) end,
    methods = {
        size = function(t) return tonumber(lib.Channels_size(t)) end,
        at = lib.Channels_at,
        copy = lib.Channels_copy,
    }
})

return Channels
