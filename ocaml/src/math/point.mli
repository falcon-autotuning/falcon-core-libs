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
  val make : Mapconnectiondouble.MapConnectionDouble.t -> Symbolunit.SymbolUnit.t -> t
  val fromParent : Mapconnectionquantity.MapConnectionQuantity.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val unit : t -> Symbolunit.SymbolUnit.t
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
  val coordinates : t -> Mapconnectionquantity.MapConnectionQuantity.t
  val connections : t -> Listconnection.ListConnection.t
  val addition : t -> t -> t
  val subtraction : t -> t -> t
  val multiplication : t -> float -> t
  val division : t -> float -> t
  val negation : t -> t
  val setUnit : t -> Symbolunit.SymbolUnit.t -> unit
end