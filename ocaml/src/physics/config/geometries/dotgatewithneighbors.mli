open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for DotGateWithNeighbors *)
class type c_dotgatewithneighbors_t = object
  method raw : unit ptr
end

class c_dotgatewithneighbors : unit ptr -> c_dotgatewithneighbors_t

module DotGateWithNeighbors : sig
  type t = c_dotgatewithneighbors

  val copy : t -> t
  val fromjson : string -> t
  val plungerGateWithNeighbors : string -> Connection.Connection.t -> Connection.Connection.t -> t
  val barrierGateWithNeighbors : string -> Connection.Connection.t -> Connection.Connection.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val name : t -> string
  val type_ : t -> string
  val leftNeighbor : t -> Connection.Connection.t
  val rightNeighbor : t -> Connection.Connection.t
  val isBarrierGate : t -> bool
  val isPlungerGate : t -> bool
end