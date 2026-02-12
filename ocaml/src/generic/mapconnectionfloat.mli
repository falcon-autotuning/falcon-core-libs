open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapConnectionFloat *)
class type c_mapconnectionfloat_t = object
  method raw : unit ptr
end

class c_mapconnectionfloat : unit ptr -> c_mapconnectionfloat_t

module MapConnectionFloat : sig
  type t = c_mapconnectionfloat

  val empty : t
  val copy : t -> t
  val make : Pairconnectionfloat.PairConnectionFloat.t -> int -> t
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
  val values : t -> Listfloat.ListFloat.t
  val items : t -> Listpairconnectionfloat.ListPairConnectionFloat.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end