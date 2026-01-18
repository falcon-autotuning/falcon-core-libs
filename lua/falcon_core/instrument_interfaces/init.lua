-- instrument_interfaces/init.lua

return {
    Port = require("falcon_core.instrument_interfaces.port"),
    Connection = require("falcon_core.instrument_interfaces.connection"),
    Connections = require("falcon_core.instrument_interfaces.connections"),
    Waveform = require("falcon_core.instrument_interfaces.waveform"),
    Channel = require("falcon_core.instrument_interfaces.channel"),
    Channels = require("falcon_core.instrument_interfaces.channels"),
    Ports = require("falcon_core.instrument_interfaces.ports"),
    Impedance = require("falcon_core.instrument_interfaces.impedance"),
    Impedances = require("falcon_core.instrument_interfaces.impedances"),
    
    -- Submodules
    port_transforms = require("falcon_core.instrument_interfaces.port_transforms"),
    names = require("falcon_core.instrument_interfaces.names"),
}
