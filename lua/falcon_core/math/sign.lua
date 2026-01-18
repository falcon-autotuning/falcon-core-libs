-- sign.lua
-- Auto-generated wrapper for Sign
-- Generated from Sign_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Sign = {}

-- Constructors


-- Methods

function Sign.positive(handle)
    return cdef.lib.Sign_positive(handle)
end

function Sign.negative(handle)
    return cdef.lib.Sign_negative(handle)
end


return Sign
