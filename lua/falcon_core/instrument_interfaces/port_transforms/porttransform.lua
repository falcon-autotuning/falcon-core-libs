-- port_transforms/porttransform.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local PortTransform = {}

function PortTransform.identity(port)
    local Port = require("falcon_core.instrument_interfaces.port")
    local s_port = (type(port) == "string") and Port.new(port) or port
    return lib.PortTransform_create_identity_transform(s_port)
end

function PortTransform.constant(port, value)
    local Port = require("falcon_core.instrument_interfaces.port")
    local s_port = (type(port) == "string") and Port.new(port) or port
    return lib.PortTransform_create_constant_transform(s_port, value)
end

song.register("PortTransform", {
    methods = {
        port = lib.PortTransform_port,
        evaluate = lib.PortTransform_evaluate,
        copy = lib.PortTransform_copy,
    }
}, PortTransform)

return PortTransform
