-- labelleddomain.lua
-- Auto-generated wrapper for LabelledDomain
-- Generated from LabelledDomain_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local LabelledDomain = {}

-- Constructors

function LabelledDomain.from_json_string(json)
    return cdef.lib.LabelledDomain_from_json_string(json)
end


-- Methods

function LabelledDomain.copy(handle)
    return cdef.lib.LabelledDomain_copy(handle)
end

function LabelledDomain.to_json_string(handle)
    return cdef.lib.LabelledDomain_to_json_string(handle)
end

function LabelledDomain.from_json_string(handle)
    return cdef.lib.LabelledDomain_from_json_string(handle)
end

function LabelledDomain.port(handle)
    return cdef.lib.LabelledDomain_port(handle)
end

function LabelledDomain.domain(handle)
    return cdef.lib.LabelledDomain_domain(handle)
end


return LabelledDomain
