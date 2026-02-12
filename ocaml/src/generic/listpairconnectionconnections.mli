open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairConnectionConnections *)
class type c_listpairconnectionconnections_t = object
  method raw : unit ptr
end

class c_listpairconnectionconnections : unit ptr -> c_listpairconnectionconnections_t

module ListPairConnectionConnections : sig
  type t = c_listpairconnectionconnections

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairconnectionconnections.PairConnectionConnections.t -> t
  val make : Pairconnectionconnections.PairConnectionConnections.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairconnectionconnections.PairConnectionConnections.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairconnectionconnections.PairConnectionConnections.t
  val items : t -> Pairconnectionconnections.PairConnectionConnections.t -> int -> int
  val contains : t -> Pairconnectionconnections.PairConnectionConnections.t -> bool
  val index : t -> Pairconnectionconnections.PairConnectionConnections.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end