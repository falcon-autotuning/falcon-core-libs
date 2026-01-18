-- group.lua
-- Wrapper for Group type (logical grouping of channels/gates)

local cdef = require("falcon_core.ffi.cdef")
local lib = cdef.lib
local song = require("falcon_core.utils.song")

local Group = {}

-- Create a new Group
-- @param args table: {name, num_dots, screening_gates, reservoir_gates, plunger_gates, barrier_gates, order}
function Group.new(args)
    local Connections = require("falcon_core.instrument_interfaces.connections")
    local Channel = require("falcon_core.instrument_interfaces.channel")
    
    local name = (type(args.name) == "string") and Channel.new(args.name) or args.name
    local screening = (type(args.screening_gates) == "table") and Connections.new(args.screening_gates) or (args.screening_gates or Connections.new())
    local reservoir = (type(args.reservoir_gates) == "table") and Connections.new(args.reservoir_gates) or (args.reservoir_gates or Connections.new())
    local plunger = (type(args.plunger_gates) == "table") and Connections.new(args.plunger_gates) or (args.plunger_gates or Connections.new())
    local barrier = (type(args.barrier_gates) == "table") and Connections.new(args.barrier_gates) or (args.barrier_gates or Connections.new())
    local order = (type(args.order) == "table") and Connections.new(args.order) or (args.order or Connections.new())
    
    print("DEBUG: Group.new args:", name, args.num_dots, screening, reservoir, plunger, barrier, order)
    
    local handle = lib.Group_create(name, args.num_dots or 1, screening, reservoir, plunger, barrier, order)
    print("DEBUG: Group_create handle:", handle)
    return handle
end

-- Register extensions for Song
song.register("Group", {
    methods = {
        name = function(self)
            local c = lib.Group_name(self)
            if c == nil then 
                return nil 
            end
            return c:name()
        end,
        num_dots = lib.Group_num_dots,
        screening_gates = lib.Group_screening_gates,
        reservoir_gates = lib.Group_reservoir_gates,
        plunger_gates = lib.Group_plunger_gates,
        barrier_gates = lib.Group_barrier_gates,
        dot_gates = lib.Group_dot_gates,
        all_gates = lib.Group_get_all_gates,
    }
}, Group)

return Group
