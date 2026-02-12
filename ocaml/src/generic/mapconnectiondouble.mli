open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapConnectionDouble *)
class type c_mapconnectiondouble_t = object
  method raw : unit ptr
end

class c_mapconnectiondouble : unit ptr -> c_mapconnectiondouble_t

module MapConnectionDouble : sig
  type t = c_mapconnectiondouble

  val empty : t
  val copy : t -> t
  val make : Pairconnectiondouble.PairConnectionDouble.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Connection.Connection.t -> float -> unit
  val insert : t -> Connection.Connection.t -> float -> unit
  val at : t -> Connection.Connection.t -> float
  val erase : t -> Connection.Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.Connection.t -> bool
  val keys : t -> Listconnection.ListConnection.t
  val values : t -> Listdouble.ListDouble.t
  val items : t -> Listpairconnectiondouble.ListPairConnectionDouble.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end