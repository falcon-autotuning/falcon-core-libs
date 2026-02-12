open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Group *)
class type c_group_t = object
  method raw : unit ptr
end

class c_group : unit ptr -> c_group_t

module Group : sig
  type t = c_group

  val copy : t -> t
  val fromjson : string -> t
  val make : Channel.Channel.t -> int -> Connections.Connections.t -> Connections.Connections.t -> Connections.Connections.t -> Connections.Connections.t -> Connections.Connections.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val name : t -> Channel.Channel.t
  val numDots : t -> int
  val order : t -> Gategeometryarray1d.GateGeometryArray1D.t
  val hasChannel : t -> Channel.Channel.t -> bool
  val isChargeSensor : t -> bool
  val getAllChannelGates : t -> Connections.Connections.t
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