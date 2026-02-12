open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Connection *)
class type c_connection_t = object
  method raw : unit ptr
end

class c_connection : unit ptr -> c_connection_t

module Connection : sig
  type t = c_connection

  val copy : t -> t
  val fromjson : string -> t
  val barrierGate : string -> t
  val plungerGate : string -> t
  val reservoirGate : string -> t
  val screeningGate : string -> t
  val ohmic : string -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val name : t -> string
  val type_ : t -> string
  val isDotGate : t -> bool
  val isBarrierGate : t -> bool
  val isPlungerGate : t -> bool
  val isReservoirGate : t -> bool
  val isScreeningGate : t -> bool
  val isOhmic : t -> bool
  val isGate : t -> bool
end