-- loader.lua
-- Auto-generated wrapper for Loader
-- Generated from Loader_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local Loader = {}

-- Constructors

function Loader.new(config_path)
    local path_handle = cdef.lib.String_wrap(config_path)
    return cdef.lib.Loader_create(path_handle)
end


-- Methods

function Loader.create(handle)
    return cdef.lib.Loader_create(handle)
end

function Loader.config(handle)
    return cdef.lib.Loader_config(handle)
end


return Loader
