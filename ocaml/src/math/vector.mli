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
  val make : Point.t -> Point.t -> t
  val fromEnd : Point.t -> t
  val fromQuantities : Mapconnectionquantity.t -> Mapconnectionquantity.t -> t
  val fromEndQuantities : Mapconnectionquantity.t -> t
  val fromDoubles : Mapconnectiondouble.t -> Mapconnectiondouble.t -> Symbolunit.t -> t
  val fromEndDoubles : Mapconnectiondouble.t -> Symbolunit.t -> t
  val fromParent : Mapconnectionquantity.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val endPoint : t -> Point.t
  val startPoint : t -> Point.t
  val endQuantities : t -> Mapconnectionquantity.t
  val startQuantities : t -> Mapconnectionquantity.t
  val endMap : t -> Mapconnectiondouble.t
  val startMap : t -> Mapconnectiondouble.t
  val connections : t -> Listconnection.t
  val unit : t -> Symbolunit.t
  val principleConnection : t -> Connection.t
  val magnitude : t -> float
  val insertOrAssign : t -> Connection.t -> Pairquantityquantity.t -> unit
  val insert : t -> Connection.t -> Pairquantityquantity.t -> unit
  val at : t -> Connection.t -> Pairquantityquantity.t
  val erase : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.t -> bool
  val keys : t -> Listconnection.t
  val values : t -> Listpairquantityquantity.t
  val items : t -> Listpairconnectionpairquantityquantity.t
  val addition : t -> t -> t
  val subtraction : t -> t -> t
  val doubleMultiplication : t -> float -> t
  val intMultiplication : t -> int -> t
  val doubleDivision : t -> float -> t
  val intDivision : t -> int -> t
  val negation : t -> t
  val updateStartFromStates : t -> Devicevoltagestates.t -> t
  val translateDoubles : t -> Mapconnectiondouble.t -> Symbolunit.t -> t
  val translateQuantities : t -> Mapconnectionquantity.t -> t
  val translate : t -> Point.t -> t
  val translateToOrigin : t -> t
  val doubleExtend : t -> float -> t
  val intExtend : t -> int -> t
  val doubleShrink : t -> float -> t
  val intShrink : t -> int -> t
  val unitVector : t -> t
  val normalize : t -> t
  val project : t -> t -> t
  val updateUnit : t -> Symbolunit.t -> unit
end