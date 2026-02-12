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
  val make : Channel.t -> int -> Connections.t -> Connections.t -> Connections.t -> Connections.t -> Connections.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val name : t -> Channel.t
  val numDots : t -> int
  val order : t -> Gategeometryarray1d.t
  val hasChannel : t -> Channel.t -> bool
  val isChargeSensor : t -> bool
  val getAllChannelGates : t -> Connections.t
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