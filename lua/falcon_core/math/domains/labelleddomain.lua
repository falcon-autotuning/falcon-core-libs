-- labelleddomain.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local LabelledDomain = {}
function LabelledDomain.new(domain, name, pseudo_name, itype, units, desc)
    local s_name = lib.String_wrap(name or "")
    local s_pseudo = (type(pseudo_name) == "string") and require("falcon_core.instrument_interfaces.connection").new(pseudo_name) or pseudo_name
    local s_itype = lib.String_wrap(itype or "")
    local s_units = (type(units) == "string") and require("falcon_core.math.symbolunit").from_string(units) or units
    local s_desc = lib.String_wrap(desc or "")
    local handle = lib.LabelledDomain_create_from_domain(domain, s_name, s_pseudo, s_itype, s_units, s_desc)
    lib.String_destroy(s_name); lib.String_destroy(s_itype); lib.String_destroy(s_desc)
    return handle
end
song.register("LabelledDomain", {
    methods = {
        domain = lib.LabelledDomain_domain,
        port = lib.LabelledDomain_port,
        name = function(self)
            local p = lib.LabelledDomain_port(self)
            return p and p:name() or nil
        end,
        lesser_bound = lib.LabelledDomain_lesser_bound,
        greater_bound = lib.LabelledDomain_greater_bound,
        contains = lib.LabelledDomain_in,
        range = lib.LabelledDomain_range,
    }
}, LabelledDomain)
return LabelledDomain
