-- instrumenttypes.lua
-- Auto-generated wrapper for InstrumentTypes
-- Generated from InstrumentTypes_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local InstrumentTypes = {}

-- Constructors


-- Methods

function InstrumentTypes.dc_voltage_source(handle)
    return cdef.lib.InstrumentTypes_dc_voltage_source(handle)
end

function InstrumentTypes.amnmeter(handle)
    return cdef.lib.InstrumentTypes_amnmeter(handle)
end

function InstrumentTypes.magnet(handle)
    return cdef.lib.InstrumentTypes_magnet(handle)
end

function InstrumentTypes.lockin(handle)
    return cdef.lib.InstrumentTypes_lockin(handle)
end

function InstrumentTypes.voltage_source(handle)
    return cdef.lib.InstrumentTypes_voltage_source(handle)
end


return InstrumentTypes
