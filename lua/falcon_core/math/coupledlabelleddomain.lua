-- coupledlabelleddomain.lua
-- Auto-generated wrapper for CoupledLabelledDomain
-- Generated from CoupledLabelledDomain_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local CoupledLabelledDomain = {}

-- Constructors

function CoupledLabelledDomain.empty()
    return cdef.lib.CoupledLabelledDomain_create_empty()
end


-- Methods

function CoupledLabelledDomain.create_empty(handle)
    return cdef.lib.CoupledLabelledDomain_create_empty(handle)
end

function CoupledLabelledDomain.labels(handle)
    return cdef.lib.CoupledLabelledDomain_labels(handle)
end

function CoupledLabelledDomain.size(handle)
    return cdef.lib.CoupledLabelledDomain_size(handle)
end

function CoupledLabelledDomain.empty(handle)
    return cdef.lib.CoupledLabelledDomain_empty(handle)
end


return CoupledLabelledDomain
