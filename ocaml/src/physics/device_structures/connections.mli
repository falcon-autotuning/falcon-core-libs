open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Connections *)
class type c_connections_t = object
  method raw : unit ptr
end

class c_connections : unit ptr -> c_connections_t

module Connections : sig
  type t = c_connections

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : Listconnection.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val isGates : t -> bool
  val isOhmics : t -> bool
  val isDotGates : t -> bool
  val isPlungerGates : t -> bool
  val isBarrierGates : t -> bool
  val isReservoirGates : t -> bool
  val isScreeningGates : t -> bool
  val intersection : t -> t -> t
  val pushBack : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Connection.t
  val items : t -> Listconnection.t
  val contains : t -> Connection.t -> bool
  val index : t -> Connection.t -> int
end