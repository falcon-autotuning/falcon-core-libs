open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Config *)
class type c_config_t = object
  method raw : unit ptr
end

class c_config : unit ptr -> c_config_t

module Config : sig
  type t = c_config

  val copy : t -> t
  val fromjson : string -> t
  val make : Connections.Connections.t -> Connections.Connections.t -> Connections.Connections.t -> Connections.Connections.t -> Connections.Connections.t -> Mapgnamegroup.MapGnameGroup.t -> Impedances.Impedances.t -> Voltageconstraints.VoltageConstraints.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val numUniqueChannels : t -> int
  val voltageConstraints : t -> Voltageconstraints.VoltageConstraints.t
  val groups : t -> Mapgnamegroup.MapGnameGroup.t
  val wiringDc : t -> Impedances.Impedances.t
  val channels : t -> Channels.Channels.t
  val getImpedance : t -> Connection.Connection.t -> Impedance.Impedance.t
  val getAllGnames : t -> Listgname.ListGname.t
  val getAllGroups : t -> Listgroup.ListGroup.t
  val hasChannel : t -> Channel.Channel.t -> bool
  val hasGname : t -> Gname.Gname.t -> bool
  val selectGroup : t -> Gname.Gname.t -> Group.Group.t
  val getDotNumber : t -> Channel.Channel.t -> int
  val getChargeSenseGroups : t -> Listgname.ListGname.t
  val ohmicInChargeSensor : t -> Connection.Connection.t -> bool
  val getAssociatedOhmic : t -> Connection.Connection.t -> Connection.Connection.t
  val getCurrentChannels : t -> Channels.Channels.t
  val getGname : t -> Channel.Channel.t -> Gname.Gname.t
  val getGroupBarrierGates : t -> Gname.Gname.t -> Connections.Connections.t
  val getGroupPlungerGates : t -> Gname.Gname.t -> Connections.Connections.t
  val getGroupReservoirGates : t -> Gname.Gname.t -> Connections.Connections.t
  val getGroupScreeningGates : t -> Gname.Gname.t -> Connections.Connections.t
  val getGroupDotGates : t -> Gname.Gname.t -> Connections.Connections.t
  val getGroupGates : t -> Gname.Gname.t -> Connections.Connections.t
  val getChannelBarrierGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getChannelPlungerGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getChannelReservoirGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getChannelScreeningGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getChannelDotGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getChannelGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getChannelOhmics : t -> Channel.Channel.t -> Connections.Connections.t
  val getChannelOrderNoOhmics : t -> Channel.Channel.t -> Connections.Connections.t
  val getNumUniqueChannels : t -> int
  val returnChannelsFromGate : t -> Connection.Connection.t -> Channels.Channels.t
  val returnChannelFromGate : t -> Connection.Connection.t -> Channel.Channel.t
  val ohmicInChannel : t -> Connection.Connection.t -> Channel.Channel.t -> bool
  val getDotChannelNeighbors : t -> Connection.Connection.t -> Pairconnectionconnection.PairConnectionConnection.t
  val getBarrierGateDict : t -> Mapchannelconnections.MapChannelConnections.t
  val getPlungerGateDict : t -> Mapchannelconnections.MapChannelConnections.t
  val getReservoirGateDict : t -> Mapchannelconnections.MapChannelConnections.t
  val getScreeningGateDict : t -> Mapchannelconnections.MapChannelConnections.t
  val getDotGateDict : t -> Mapchannelconnections.MapChannelConnections.t
  val getGateDict : t -> Mapchannelconnections.MapChannelConnections.t
  val getIsolatedBarrierGates : t -> Connections.Connections.t
  val getIsolatedPlungerGates : t -> Connections.Connections.t
  val getIsolatedReservoirGates : t -> Connections.Connections.t
  val getIsolatedScreeningGates : t -> Connections.Connections.t
  val getIsolatedDotGates : t -> Connections.Connections.t
  val getIsolatedGates : t -> Connections.Connections.t
  val getSharedBarrierGates : t -> Connections.Connections.t
  val getSharedPlungerGates : t -> Connections.Connections.t
  val getSharedReservoirGates : t -> Connections.Connections.t
  val getSharedScreeningGates : t -> Connections.Connections.t
  val getSharedDotGates : t -> Connections.Connections.t
  val getSharedGates : t -> Connections.Connections.t
  val getSharedChannelBarrierGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getSharedChannelPlungerGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getSharedChannelReservoirGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getSharedChannelScreeningGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getSharedChannelDotGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getSharedChannelGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getIsolatedChannelBarrierGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getIsolatedChannelPlungerGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getIsolatedChannelReservoirGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getIsolatedChannelScreeningGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getIsolatedChannelDotGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getIsolatedChannelGates : t -> Channel.Channel.t -> Connections.Connections.t
  val getIsolatedBarrierGatesByChannel : t -> Mapchannelconnections.MapChannelConnections.t
  val getIsolatedPlungerGatesByChannel : t -> Mapchannelconnections.MapChannelConnections.t
  val getIsolatedReservoirGatesByChannel : t -> Mapchannelconnections.MapChannelConnections.t
  val getIsolatedScreeningGatesByChannel : t -> Mapchannelconnections.MapChannelConnections.t
  val getIsolatedDotGatesByChannel : t -> Mapchannelconnections.MapChannelConnections.t
  val getIsolatedGatesByChannel : t -> Mapchannelconnections.MapChannelConnections.t
  val generateGateRelations : t -> Gaterelations.GateRelations.t
  val screeningGates : t -> Connections.Connections.t
  val reservoirGates : t -> Connections.Connections.t
  val plungerGates : t -> Connections.Connections.t
  val barrierGates : t -> Connections.Connections.t
  val ohmics : t -> Connections.Connections.t
  val dotGates : t -> Connections.Connections.t
  val getOhmic : t -> Connection.Connection.t
  val getBarrierGate : t -> Connection.Connection.t
  val getPlungerGate : t -> Connection.Connection.t
  val getReservoirGate : t -> Connection.Connection.t
  val getScreeningGate : t -> Connection.Connection.t
  val getDotGate : t -> Connection.Connection.t
  val getGate : t -> Connection.Connection.t
  val getAllGates : t -> Connections.Connections.t
  val getAllConnections : t -> Connections.Connections.t
  val hasOhmic : t -> Connection.Connection.t -> bool
  val hasGate : t -> Connection.Connection.t -> bool
  val hasBarrierGate : t -> Connection.Connection.t -> bool
  val hasPlungerGate : t -> Connection.Connection.t -> bool
  val hasReservoirGate : t -> Connection.Connection.t -> bool
  val hasScreeningGate : t -> Connection.Connection.t -> bool
end