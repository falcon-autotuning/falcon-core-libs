-- math/quantity.lua
-- Wrapper for Quantity type (value + unit)

local cdef = require("falcon_core.ffi.cdef")
local ffi = require("ffi")
local lib = cdef.lib
local song = require("falcon_core.utils.song")

local Quantity = {}

-- Create a new Quantity from value and unit
-- @param value number: Value
-- @param unit SymbolUnitHandle or string: Unit
function Quantity.new(value, unit)
    -- Handle unit as either SymbolUnitHandle or string
    local unit_handle
    if type(unit) == "string" then
        local SymbolUnit = require("falcon_core.math.symbolunit")
        unit_handle = SymbolUnit.from_string(unit)
    else
        unit_handle = unit
    end
    
    if unit_handle == nil then return nil end
    return lib.Quantity_create(value, unit_handle)
end

-- Arithmetic methods
function Quantity.add(a, b) 
    return lib.Quantity_add_quantity(a, b) 
end

function Quantity.subtract(a, b) 
    return lib.Quantity_subtract_quantity(a, b) 
end

function Quantity.multiply(a, b) 
    if type(b) == "number" then 
        return lib.Quantity_multiply_double(a, b)
    else 
        return lib.Quantity_multiply_quantity(a, b) 
    end
end

function Quantity.divide(a, b)
    if type(b) == "number" then 
        return lib.Quantity_divide_double(a, b)
    else 
        return lib.Quantity_divide_quantity(a, b) 
    end
end

-- Register extensions for Song
song.register("Quantity", {
    __add = Quantity.add,
    __sub = Quantity.subtract,
    __mul = Quantity.multiply,
    __div = Quantity.divide,
    __unm = lib.Quantity_negate,
    methods = {
        add = Quantity.add,
        subtract = Quantity.subtract,
        multiply = Quantity.multiply,
        divide = Quantity.divide,
        value = lib.Quantity_value,
        unit = lib.Quantity_unit,
        convert_to = lib.Quantity_convert_to,
    }
}, Quantity)

return Quantity
