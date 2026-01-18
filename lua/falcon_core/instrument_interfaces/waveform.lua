-- waveform.lua
-- Auto-generated wrapper for Waveform
-- Generated from Waveform_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Waveform = {}

-- Constructors

function Waveform.from_json_string(json)
    return cdef.lib.Waveform_from_json_string(json)
end


-- Methods

function Waveform.copy(handle)
    return cdef.lib.Waveform_copy(handle)
end

function Waveform.equal(handle, other)
    return cdef.lib.Waveform_equal(handle, other)
end

function Waveform.not_equal(handle, other)
    return cdef.lib.Waveform_not_equal(handle, other)
end

function Waveform.to_json_string(handle)
    return cdef.lib.Waveform_to_json_string(handle)
end

function Waveform.from_json_string(handle)
    return cdef.lib.Waveform_from_json_string(handle)
end


return Waveform
