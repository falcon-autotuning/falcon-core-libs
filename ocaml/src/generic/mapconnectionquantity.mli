open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapConnectionQuantity *)
class type c_mapconnectionquantity_t = object
  method raw : unit ptr
end

class c_mapconnectionquantity : unit ptr -> c_mapconnectionquantity_t

module MapConnectionQuantity : sig
  type t = c_mapconnectionquantity

  val empty : t
  val copy : t -> t
  val make : Pairconnectionquantity.PairConnectionQuantity.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Connection.Connection.t -> Quantity.Quantity.t -> unit
  val insert : t -> Connection.Connection.t -> Quantity.Quantity.t -> unit
  val at : t -> Connection.Connection.t -> Quantity.Quantity.t
  val erase : t -> Connection.Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.Connection.t -> bool
  val keys : t -> Listconnection.ListConnection.t
  val values : t -> Listquantity.ListQuantity.t
  val items : t -> Listpairconnectionquantity.ListPairConnectionQuantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end