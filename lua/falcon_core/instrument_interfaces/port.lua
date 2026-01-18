-- instrument/port.lua
-- Wrapper for InstrumentPort and related types

local cdef = require("falcon_core.ffi.cdef")

local Port = {}

-- Get port name
function Port.name(port)
    local lib = cdef.lib
    local str_handle = lib.InstrumentPort_name(port)
    local name = require("ffi").string(str_handle.raw, str_handle.length)
    lib.String_destroy(str_handle)
    return name
end

-- Get acquisition context
function Port.acquisition_context(port)
    return cdef.lib.InstrumentPort_acquisition_context(port)
end

return Port
