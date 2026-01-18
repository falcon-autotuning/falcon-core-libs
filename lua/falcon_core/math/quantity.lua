-- math/quantity.lua
-- Wrapper for Quantity type (value + unit)

local cdef = require("falcon_core.ffi.cdef")
local ffi = require("ffi")

local Quantity = {}

-- Create a new Quantity from value and unit
function Quantity.new(value, unit)
    local lib = cdef.lib
    
    -- Handle unit as either SymbolUnitHandle or string
    local unit_handle
    if type(unit) == "string" then
        -- Create SymbolUnit from string (assuming helper exists)
        local c_str = lib.String_wrap(unit)
        unit_handle = lib.SymbolUnit_from_string(c_str)
        lib.String_destroy(c_str)
    else
        -- Assume it's already a SymbolUnitHandle
        unit_handle = unit
    end
    
    return lib.Quantity_create(value, unit_handle)
end

-- Arithmetic operations (convenience wrappers)
function Quantity.add(q1, q2)
    local lib = cdef.lib
    return lib.Quantity_add_quantity(q1, q2)
end

function Quantity.subtract(q1, q2)
    local lib = cdef.lib
    return lib.Quantity_subtract_quantity(q1, q2)
end

function Quantity.multiply(q, scalar)
    local lib = cdef.lib
    if type(scalar) == "number" then
        return lib.Quantity_multiply_double(q, scalar)
    else
        return lib.Quantity_multiply_quantity(q, scalar)
    end
end

function Quantity.divide(q, scalar)
    local lib = cdef.lib
    if type(scalar) == "number" then
        return lib.Quantity_divide_double(q, scalar)
    else
        return lib.Quantity_divide_quantity(q, scalar)
    end
end

-- Get value and unit
function Quantity.value(q)
    return cdef.lib.Quantity_value(q)
end

function Quantity.unit(q)
    return cdef.lib.Quantity_unit(q)
end

-- Unit conversion
function Quantity.convert_to(q, target_unit)
    cdef.lib.Quantity_convert_to(q, target_unit)
end

return Quantity
