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
  val make : Pairconnectionfloat.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Connection.t -> float -> unit
  val insert : t -> Connection.t -> float -> unit
  val at : t -> Connection.t -> float
  val erase : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.t -> bool
  val keys : t -> Listconnection.t
  val values : t -> Listfloat.t
  val items : t -> Listpairconnectionfloat.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end