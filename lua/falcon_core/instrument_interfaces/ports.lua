-- ports.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Ports = {}

function Ports.new(list)
    if not list then return lib.Ports_create(lib.ListInstrumentPort_create_empty()) end
    local ListPort = require("falcon_core.generic.list").new("instrument_port")
    local Port = require("falcon_core.instrument_interfaces.port")
    for _, name in ipairs(list) do
        local p = (type(name) == "string") and Port.new(name) or name
        lib.ListInstrumentPort_push_back(ListPort, p)
    end
    local handle = lib.Ports_create(ListPort)
    lib.ListInstrumentPort_destroy(ListPort)
    return handle
end

song.register("Ports", {
    __len = function(t) 
        local list = lib.Ports_ports(t)
        local n = tonumber(lib.ListInstrumentPort_size(list))
        lib.ListInstrumentPort_destroy(list)
        return n
    end,
    methods = {
        size = function(t) 
            local list = lib.Ports_ports(t)
            local n = tonumber(lib.ListInstrumentPort_size(list))
            lib.ListInstrumentPort_destroy(list)
            return n
        end,
        at = lib.Ports_at,
        contains = lib.Ports_contains,
    }
}, Ports)

return Ports
