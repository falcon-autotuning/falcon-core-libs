open Ctypes

open Falcon_core.Communications.Voltage_states
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

(** Opaque handle for Vector *)
class type c_vector_t = object
  method raw : unit ptr
end

class c_vector : unit ptr -> c_vector_t

module Vector : sig
  type t = c_vector

end

module Vector : sig
  type t = c_vector

  val copy : t -> t
  val fromjson : string -> t
  val make : Point.t -> Point.t -> t
  val fromEnd : Point.t -> t
  val fromQuantities : MapConnectionQuantity.t -> MapConnectionQuantity.t -> t
  val fromEndQuantities : MapConnectionQuantity.t -> t
  val fromDoubles : MapConnectionDouble.t -> MapConnectionDouble.t -> SymbolUnit.t -> t
  val fromEndDoubles : MapConnectionDouble.t -> SymbolUnit.t -> t
  val fromParent : MapConnectionQuantity.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val endPoint : t -> Point.t
  val startPoint : t -> Point.t
  val endQuantities : t -> MapConnectionQuantity.t
  val startQuantities : t -> MapConnectionQuantity.t
  val endMap : t -> MapConnectionDouble.t
  val startMap : t -> MapConnectionDouble.t
  val connections : t -> ListConnection.t
  val unit : t -> SymbolUnit.t
  val principleConnection : t -> Connection.t
  val magnitude : t -> float
  val insertOrAssign : t -> Connection.t -> PairQuantityQuantity.t -> unit
  val insert : t -> Connection.t -> PairQuantityQuantity.t -> unit
  val at : t -> Connection.t -> PairQuantityQuantity.t
  val erase : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.t -> bool
  val keys : t -> ListConnection.t
  val values : t -> ListPairQuantityQuantity.t
  val items : t -> ListPairConnectionPairQuantityQuantity.t
  val addition : t -> t -> t
  val subtraction : t -> t -> t
  val doubleMultiplication : t -> float -> t
  val intMultiplication : t -> int -> t
  val doubleDivision : t -> float -> t
  val intDivision : t -> int -> t
  val negation : t -> t
  val updateStartFromStates : t -> DeviceVoltageStates.t -> t
  val translateDoubles : t -> MapConnectionDouble.t -> SymbolUnit.t -> t
  val translateQuantities : t -> MapConnectionQuantity.t -> t
  val translate : t -> Point.t -> t
  val translateToOrigin : t -> t
  val doubleExtend : t -> float -> t
  val intExtend : t -> int -> t
  val doubleShrink : t -> float -> t
  val intShrink : t -> int -> t
  val unitVector : t -> t
  val normalize : t -> t
  val project : t -> t -> t
  val updateUnit : t -> SymbolUnit.t -> unit
end