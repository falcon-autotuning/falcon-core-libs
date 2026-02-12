open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Vector *)
class type c_vector_t = object
  method raw : unit ptr
end

class c_vector : unit ptr -> c_vector_t

module Vector : sig
  type t = c_vector

  val copy : t -> t
  val fromjson : string -> t
  val make : Point.Point.t -> Point.Point.t -> t
  val fromEnd : Point.Point.t -> t
  val fromQuantities : Mapconnectionquantity.MapConnectionQuantity.t -> Mapconnectionquantity.MapConnectionQuantity.t -> t
  val fromEndQuantities : Mapconnectionquantity.MapConnectionQuantity.t -> t
  val fromDoubles : Mapconnectiondouble.MapConnectionDouble.t -> Mapconnectiondouble.MapConnectionDouble.t -> Symbolunit.SymbolUnit.t -> t
  val fromEndDoubles : Mapconnectiondouble.MapConnectionDouble.t -> Symbolunit.SymbolUnit.t -> t
  val fromParent : Mapconnectionquantity.MapConnectionQuantity.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val endPoint : t -> Point.Point.t
  val startPoint : t -> Point.Point.t
  val endQuantities : t -> Mapconnectionquantity.MapConnectionQuantity.t
  val startQuantities : t -> Mapconnectionquantity.MapConnectionQuantity.t
  val endMap : t -> Mapconnectiondouble.MapConnectionDouble.t
  val startMap : t -> Mapconnectiondouble.MapConnectionDouble.t
  val connections : t -> Listconnection.ListConnection.t
  val unit : t -> Symbolunit.SymbolUnit.t
  val principleConnection : t -> Connection.Connection.t
  val magnitude : t -> float
  val insertOrAssign : t -> Connection.Connection.t -> Pairquantityquantity.PairQuantityQuantity.t -> unit
  val insert : t -> Connection.Connection.t -> Pairquantityquantity.PairQuantityQuantity.t -> unit
  val at : t -> Connection.Connection.t -> Pairquantityquantity.PairQuantityQuantity.t
  val erase : t -> Connection.Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.Connection.t -> bool
  val keys : t -> Listconnection.ListConnection.t
  val values : t -> Listpairquantityquantity.ListPairQuantityQuantity.t
  val items : t -> Listpairconnectionpairquantityquantity.ListPairConnectionPairQuantityQuantity.t
  val addition : t -> t -> t
  val subtraction : t -> t -> t
  val doubleMultiplication : t -> float -> t
  val intMultiplication : t -> int -> t
  val doubleDivision : t -> float -> t
  val intDivision : t -> int -> t
  val negation : t -> t
  val updateStartFromStates : t -> Devicevoltagestates.DeviceVoltageStates.t -> t
  val translateDoubles : t -> Mapconnectiondouble.MapConnectionDouble.t -> Symbolunit.SymbolUnit.t -> t
  val translateQuantities : t -> Mapconnectionquantity.MapConnectionQuantity.t -> t
  val translate : t -> Point.Point.t -> t
  val translateToOrigin : t -> t
  val doubleExtend : t -> float -> t
  val intExtend : t -> int -> t
  val doubleShrink : t -> float -> t
  val intShrink : t -> int -> t
  val unitVector : t -> t
  val normalize : t -> t
  val project : t -> t -> t
  val updateUnit : t -> Symbolunit.SymbolUnit.t -> unit
end