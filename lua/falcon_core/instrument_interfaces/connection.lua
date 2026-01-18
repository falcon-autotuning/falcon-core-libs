-- instrument/connection.lua
-- Wrapper for Connection type

local cdef = require("falcon_core.ffi.cdef")
local ffi = require("ffi")
local lib = cdef.lib

local Connection = {}

-- Create a new Connection from name
function Connection.new(name, ctype)
    -- Using the most flexible way: screening gate (often used as generic)
    -- or Connection_from_json_string if we had the full format.
    local s = lib.String_wrap(name)
    local conn
    if ctype == "BARRIER" then conn = lib.Connection_create_barrier_gate(s)
    elseif ctype == "PLUNGER" then conn = lib.Connection_create_plunger_gate(s)
    elseif ctype == "RESERVOIR" then conn = lib.Connection_create_reservoir_gate(s)
    elseif ctype == "OHMIC" then conn = lib.Connection_create_ohmic(s)
    else conn = lib.Connection_create_screening_gate(s) end
    
    lib.String_destroy(s)
    return conn
end

-- Get connection name
function Connection.name(conn)
    local str_handle = lib.Connection_name(conn)
    if str_handle == nil then return "Connection{?}" end
    local name = ffi.string(str_handle.raw, str_handle.length)
    lib.String_destroy(str_handle)
    return name
end

-- Bind metatype
ffi.metatype("Connection_s", {
    __index = Connection,
    __tostring = Connection.name,
    __gc = lib.Connection_destroy
})

return Connection
