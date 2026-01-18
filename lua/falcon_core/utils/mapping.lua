-- utils/mapping.lua
-- Helper for creating C-API maps from Lua tables

local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib

local Mapping = {}

-- Create a MapConnectionQuantity from a Lua table {["G1"] = quantity_handle, ...}
function Mapping.to_map_connection_quantity(t)
    local map = lib.MapConnectionQuantity_create_empty()
    local Connection = require("falcon_core.instrument_interfaces.connection")
    local Quantity = require("falcon_core.math.quantity")
    
    for k, v in pairs(t or {}) do
        local conn_handle
        if type(k) == "string" then
            conn_handle = Connection.new(k)
        else
            conn_handle = k
        end
        
        local quant_handle
        if type(v) == "number" then
            -- Default to dimensionless or something? 
            -- Better to assume the user provides a Quantity or we use a default unit if we knew it.
            -- For now, let's assume they provide a Quantity or we throw an error for ambiguity
            -- unless we have a 'default' unit.
            error("Ambiguous mapping: please provide a Quantity object for value '" .. tostring(v) .. "'")
        else
            quant_handle = v
        end
        
        lib.MapConnectionQuantity_insert_or_assign(map, conn_handle, quant_handle)
    end
    
    return map
end

return Mapping
