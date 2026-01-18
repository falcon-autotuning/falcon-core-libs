-- symbolunit.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local SymbolUnit = {}

function SymbolUnit.from_string(unit_str)
    local creators = {
        ["V"] = lib.SymbolUnit_create_volt,
        ["mV"] = lib.SymbolUnit_create_millivolt,
        ["kV"] = lib.SymbolUnit_create_kilovolt,
        ["A"] = lib.SymbolUnit_create_ampere,
        ["mA"] = lib.SymbolUnit_create_milliampere,
        ["uA"] = lib.SymbolUnit_create_microampere,
        ["nA"] = lib.SymbolUnit_create_nanoampere,
        ["pA"] = lib.SymbolUnit_create_picoampere,
        ["Hz"] = lib.SymbolUnit_create_hertz,
        ["kHz"] = lib.SymbolUnit_create_kilohertz,
        ["MHz"] = lib.SymbolUnit_create_megahertz,
        ["GHz"] = lib.SymbolUnit_create_gigahertz,
        ["s"] = lib.SymbolUnit_create_second,
        ["ms"] = lib.SymbolUnit_create_millisecond,
        ["us"] = lib.SymbolUnit_create_microsecond,
        ["ns"] = lib.SymbolUnit_create_nanosecond,
        ["ps"] = lib.SymbolUnit_create_picosecond,
        ["m"] = lib.SymbolUnit_create_meter,
        ["mm"] = lib.SymbolUnit_create_millimeter,
        ["km"] = lib.SymbolUnit_create_kilometer,
        ["K"] = lib.SymbolUnit_create_kelvin,
        ["Ohm"] = lib.SymbolUnit_create_ohm,
        ["mOhm"] = lib.SymbolUnit_create_milliohm,
        ["kOhm"] = lib.SymbolUnit_create_kiloohm,
        ["MOhm"] = lib.SymbolUnit_create_megaohm,
        ["dimensionless"] = lib.SymbolUnit_create_dimensionless,
        ["%"] = lib.SymbolUnit_create_percent,
        ["rad"] = lib.SymbolUnit_create_radian,
    }
    -- Check for exact match
    if creators[unit_str] then return creators[unit_str]() end
    
    -- Fallback to JSON for complex units
    local s = lib.String_wrap(unit_str)
    local handle = lib.SymbolUnit_from_json_string(s)
    lib.String_destroy(s)
    return handle
end

song.register("SymbolUnit", {
    __mul = lib.SymbolUnit_multiplication,
    __div = lib.SymbolUnit_division,
    static_methods = {
        from_string = SymbolUnit.from_string,
        from_volt = lib.SymbolUnit_create_volt,
        from_millivolt = lib.SymbolUnit_create_millivolt,
        from_kilovolt = lib.SymbolUnit_create_kilovolt,
        from_ampere = lib.SymbolUnit_create_ampere,
        from_milliampere = lib.SymbolUnit_create_milliampere,
        from_microampere = lib.SymbolUnit_create_microampere,
        from_nanoampere = lib.SymbolUnit_create_nanoampere,
        from_picoampere = lib.SymbolUnit_create_picoampere,
        from_hertz = lib.SymbolUnit_create_hertz,
        from_kilohertz = lib.SymbolUnit_create_kilohertz,
        from_megahertz = lib.SymbolUnit_create_megahertz,
        from_gigahertz = lib.SymbolUnit_create_gigahertz,
        from_second = lib.SymbolUnit_create_second,
        from_millisecond = lib.SymbolUnit_create_millisecond,
        from_microsecond = lib.SymbolUnit_create_microsecond,
        from_nanosecond = lib.SymbolUnit_create_nanosecond,
        from_picosecond = lib.SymbolUnit_create_picosecond,
        from_meter = lib.SymbolUnit_create_meter,
        from_millimeter = lib.SymbolUnit_create_millimeter,
        from_kilometer = lib.SymbolUnit_create_kilometer,
        from_kelvin = lib.SymbolUnit_create_kelvin,
        from_ohm = lib.SymbolUnit_create_ohm,
        from_milliohm = lib.SymbolUnit_create_milliohm,
    },
    methods = {
        symbol = function(self)
            local h = lib.SymbolUnit_symbol(self)
            if h == nil then return "" end
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
        name = function(self)
            local h = lib.SymbolUnit_name(self)
            if h == nil then return "" end
            local ffi = require("ffi")
            local str = ffi.string(h.raw, h.length)
            lib.String_destroy(h)
            return str
        end,
        is_compatible_with = lib.SymbolUnit_is_compatible_with,
        convert_to = lib.SymbolUnit_convert_value_to,
    }
}, SymbolUnit)

return SymbolUnit
