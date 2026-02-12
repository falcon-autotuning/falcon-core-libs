open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Point *)
class type c_point_t = object
  method raw : unit ptr
end

class c_point : unit ptr -> c_point_t

module Point : sig
  type t = c_point

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : Mapconnectiondouble.t -> Symbolunit.t -> t
  val fromParent : Mapconnectionquantity.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val unit : t -> Symbolunit.t
  val insertOrAssign : t -> Connection.t -> Quantity.t -> unit
  val insert : t -> Connection.t -> Quantity.t -> unit
  val at : t -> Connection.t -> Quantity.t
  val erase : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.t -> bool
  val keys : t -> Listconnection.t
  val values : t -> Listquantity.t
  val items : t -> Listpairconnectionquantity.t
  val coordinates : t -> Mapconnectionquantity.t
  val connections : t -> Listconnection.t
  val addition : t -> t -> t
  val subtraction : t -> t -> t
  val multiplication : t -> float -> t
  val division : t -> float -> t
  val negation : t -> t
  val setUnit : t -> Symbolunit.t -> unit
end