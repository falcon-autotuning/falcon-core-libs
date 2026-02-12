open Ctypes

open Falcon_core.Autotuner_interfaces.Names
open Falcon_core.Autotuner_interfaces.Names
open Falcon_core.Autotuner_interfaces.Names
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Config.Core
open Falcon_core.Physics.Config.Core
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures

(** Opaque handle for Config *)
class type c_config_t = object
  method raw : unit ptr
end

class c_config : unit ptr -> c_config_t

module Config : sig
  type t = c_config

end

module Config : sig
  type t = c_config

  val copy : t -> t
  val fromjson : string -> t
  val make : Connections.t -> Connections.t -> Connections.t -> Connections.t -> Connections.t -> MapGnameGroup.t -> Impedances.t -> VoltageConstraints.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val numUniqueChannels : t -> int
  val voltageConstraints : t -> VoltageConstraints.t
  val groups : t -> MapGnameGroup.t
  val wiringDc : t -> Impedances.t
  val channels : t -> Channels.t
  val getImpedance : t -> Connection.t -> Impedance.t
  val getAllGnames : t -> ListGname.t
  val getAllGroups : t -> ListGroup.t
  val hasChannel : t -> Channel.t -> bool
  val hasGname : t -> Gname.t -> bool
  val selectGroup : t -> Gname.t -> Group.t
  val getDotNumber : t -> Channel.t -> int
  val getChargeSenseGroups : t -> ListGname.t
  val ohmicInChargeSensor : t -> Connection.t -> bool
  val getAssociatedOhmic : t -> Connection.t -> Connection.t
  val getCurrentChannels : t -> Channels.t
  val getGname : t -> Channel.t -> Gname.t
  val getGroupBarrierGates : t -> Gname.t -> Connections.t
  val getGroupPlungerGates : t -> Gname.t -> Connections.t
  val getGroupReservoirGates : t -> Gname.t -> Connections.t
  val getGroupScreeningGates : t -> Gname.t -> Connections.t
  val getGroupDotGates : t -> Gname.t -> Connections.t
  val getGroupGates : t -> Gname.t -> Connections.t
  val getChannelBarrierGates : t -> Channel.t -> Connections.t
  val getChannelPlungerGates : t -> Channel.t -> Connections.t
  val getChannelReservoirGates : t -> Channel.t -> Connections.t
  val getChannelScreeningGates : t -> Channel.t -> Connections.t
  val getChannelDotGates : t -> Channel.t -> Connections.t
  val getChannelGates : t -> Channel.t -> Connections.t
  val getChannelOhmics : t -> Channel.t -> Connections.t
  val getChannelOrderNoOhmics : t -> Channel.t -> Connections.t
  val getNumUniqueChannels : t -> int
  val returnChannelsFromGate : t -> Connection.t -> Channels.t
  val returnChannelFromGate : t -> Connection.t -> Channel.t
  val ohmicInChannel : t -> Connection.t -> Channel.t -> bool
  val getDotChannelNeighbors : t -> Connection.t -> PairConnectionConnection.t
  val getBarrierGateDict : t -> MapChannelConnections.t
  val getPlungerGateDict : t -> MapChannelConnections.t
  val getReservoirGateDict : t -> MapChannelConnections.t
  val getScreeningGateDict : t -> MapChannelConnections.t
  val getDotGateDict : t -> MapChannelConnections.t
  val getGateDict : t -> MapChannelConnections.t
  val getIsolatedBarrierGates : t -> Connections.t
  val getIsolatedPlungerGates : t -> Connections.t
  val getIsolatedReservoirGates : t -> Connections.t
  val getIsolatedScreeningGates : t -> Connections.t
  val getIsolatedDotGates : t -> Connections.t
  val getIsolatedGates : t -> Connections.t
  val getSharedBarrierGates : t -> Connections.t
  val getSharedPlungerGates : t -> Connections.t
  val getSharedReservoirGates : t -> Connections.t
  val getSharedScreeningGates : t -> Connections.t
  val getSharedDotGates : t -> Connections.t
  val getSharedGates : t -> Connections.t
  val getSharedChannelBarrierGates : t -> Channel.t -> Connections.t
  val getSharedChannelPlungerGates : t -> Channel.t -> Connections.t
  val getSharedChannelReservoirGates : t -> Channel.t -> Connections.t
  val getSharedChannelScreeningGates : t -> Channel.t -> Connections.t
  val getSharedChannelDotGates : t -> Channel.t -> Connections.t
  val getSharedChannelGates : t -> Channel.t -> Connections.t
  val getIsolatedChannelBarrierGates : t -> Channel.t -> Connections.t
  val getIsolatedChannelPlungerGates : t -> Channel.t -> Connections.t
  val getIsolatedChannelReservoirGates : t -> Channel.t -> Connections.t
  val getIsolatedChannelScreeningGates : t -> Channel.t -> Connections.t
  val getIsolatedChannelDotGates : t -> Channel.t -> Connections.t
  val getIsolatedChannelGates : t -> Channel.t -> Connections.t
  val getIsolatedBarrierGatesByChannel : t -> MapChannelConnections.t
  val getIsolatedPlungerGatesByChannel : t -> MapChannelConnections.t
  val getIsolatedReservoirGatesByChannel : t -> MapChannelConnections.t
  val getIsolatedScreeningGatesByChannel : t -> MapChannelConnections.t
  val getIsolatedDotGatesByChannel : t -> MapChannelConnections.t
  val getIsolatedGatesByChannel : t -> MapChannelConnections.t
  val generateGateRelations : t -> GateRelations.t
  val screeningGates : t -> Connections.t
  val reservoirGates : t -> Connections.t
  val plungerGates : t -> Connections.t
  val barrierGates : t -> Connections.t
  val ohmics : t -> Connections.t
  val dotGates : t -> Connections.t
  val getOhmic : t -> Connection.t
  val getBarrierGate : t -> Connection.t
  val getPlungerGate : t -> Connection.t
  val getReservoirGate : t -> Connection.t
  val getScreeningGate : t -> Connection.t
  val getDotGate : t -> Connection.t
  val getGate : t -> Connection.t
  val getAllGates : t -> Connections.t
  val getAllConnections : t -> Connections.t
  val hasOhmic : t -> Connection.t -> bool
  val hasGate : t -> Connection.t -> bool
  val hasBarrierGate : t -> Connection.t -> bool
  val hasPlungerGate : t -> Connection.t -> bool
  val hasReservoirGate : t -> Connection.t -> bool
  val hasScreeningGate : t -> Connection.t -> bool
end