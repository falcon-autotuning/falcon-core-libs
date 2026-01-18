-- acquisitioncontext.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local AcquisitionContext = {}

song.register("AcquisitionContext", {
    methods = {
        connection = lib.AcquisitionContext_connection,
        instrument_type = lib.AcquisitionContext_instrument_type,
        units = lib.AcquisitionContext_units,
        match_connection = lib.AcquisitionContext_match_connection,
        match_instrument_type = lib.AcquisitionContext_match_instrument_type,
    }
}, AcquisitionContext)

return AcquisitionContext
