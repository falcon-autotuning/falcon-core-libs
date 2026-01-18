-- instrument/connection.lua
-- Wrapper for Connection type

local cdef = require("falcon_core.ffi.cdef")

local Connection = {}

-- Get connection name
function Connection.name(conn)
    local lib = cdef.lib
    local str_handle = lib.Connection_name(conn)
    local name = require("ffi").string(str_handle.raw, str_handle.length)
    lib.String_destroy(str_handle)
    return name
end

return Connection
