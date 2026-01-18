-- impedance.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Impedance = {}

function Impedance.new(connection, resistance, capacitance)
    local s_conn = (type(connection) == "string") and require("falcon_core.instrument_interfaces.connection").new(connection) or connection
    return lib.Impedance_create(s_conn, resistance or 0, capacitance or 0)
end

song.register("Impedance", {
    methods = {
        connection = lib.Impedance_connection,
        resistance = lib.Impedance_resistance,
        capacitance = lib.Impedance_capacitance,
        equal = lib.Impedance_equal,
    }
}, Impedance)

return Impedance
