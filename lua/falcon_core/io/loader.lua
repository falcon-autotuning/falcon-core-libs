-- loader.lua
-- Auto-generated wrapper for Loader
-- Generated from Loader_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Loader = {}

-- Constructors

function Loader.new(config_path)
    return cdef.lib.Loader_create(config_path)
end


-- Methods

function Loader.create(handle)
    return cdef.lib.Loader_create(handle)
end

function Loader.config(handle)
    return cdef.lib.Loader_config(handle)
end


return Loader
