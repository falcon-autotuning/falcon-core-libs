open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairConnectionConnections *)
class type c_pairconnectionconnections_t = object
  method raw : unit ptr
end

class c_pairconnectionconnections : unit ptr -> c_pairconnectionconnections_t

module PairConnectionConnections : sig
  type t = c_pairconnectionconnections

  val make : Connection.Connection.t -> Connections.Connections.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Connection.Connection.t
  val second : t -> Connections.Connections.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end