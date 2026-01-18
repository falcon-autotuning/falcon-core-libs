-- domain.lua
local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")
local Domain = {}
function Domain.new(min_val, max_val, min_incl, max_incl)
    return lib.Domain_create(min_val, max_val, min_incl or false, max_incl or false)
end
song.register("Domain", {
    methods = {
        lesser_bound = lib.Domain_lesser_bound,
        greater_bound = lib.Domain_greater_bound,
        lesser_bound_contained = lib.Domain_lesser_bound_contained,
        greater_bound_contained = lib.Domain_greater_bound_contained,
        range = lib.Domain_range,
        center = lib.Domain_center,
        contains = lib.Domain_in,
    }
}, Domain)
return Domain
