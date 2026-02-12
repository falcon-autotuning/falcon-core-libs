open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for GateRelations *)
class type c_gaterelations_t = object
  method raw : unit ptr
end

class c_gaterelations : unit ptr -> c_gaterelations_t

module GateRelations : sig
  type t = c_gaterelations

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : Listpairconnectionconnections.ListPairConnectionConnections.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val insertOrAssign : t -> Connection.Connection.t -> Connections.Connections.t -> unit
  val insert : t -> Connection.Connection.t -> Connections.Connections.t -> unit
  val at : t -> Connection.Connection.t -> Connections.Connections.t
  val erase : t -> Connection.Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.Connection.t -> bool
  val keys : t -> Listconnection.ListConnection.t
  val values : t -> Listconnections.ListConnections.t
  val items : t -> Listpairconnectionconnections.ListPairConnectionConnections.t
end