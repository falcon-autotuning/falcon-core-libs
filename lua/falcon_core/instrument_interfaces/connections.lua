-- connections.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Connections = {}

function Connections.new(list)
    local ListConnection = require("falcon_core.generic.list").new("connection")
    local Connection = require("falcon_core.instrument_interfaces.connection")
    for _, name in ipairs(list or {}) do
        local c = (type(name) == "string") and Connection.new(name) or name
        lib.ListConnection_push_back(ListConnection, c)
    end
    local handle = lib.Connections_create(ListConnection)
    lib.ListConnection_destroy(ListConnection)
    return handle
end

song.register("Connections", {
    __len = function(t) 
        local list = lib.Connections_items(t)
        local n = tonumber(lib.ListConnection_size(list))
        lib.ListConnection_destroy(list)
        return n
    end,
    methods = {
        size = function(t) 
            local list = lib.Connections_items(t)
            local n = tonumber(lib.ListConnection_size(list))
            lib.ListConnection_destroy(list)
            return n
        end,
        at = lib.Connections_at,
        copy = lib.Connections_copy,
        equal = lib.Connections_equal,
    }
}, Connections)

return Connections
