open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

(** Opaque handle for Point *)
class type c_point_t = object
  method raw : unit ptr
end

class c_point : unit ptr -> c_point_t

module Point : sig
  type t = c_point

end

module Point : sig
  type t = c_point

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : MapConnectionDouble.t -> SymbolUnit.t -> t
  val fromParent : MapConnectionQuantity.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val unit : t -> SymbolUnit.t
  val insertOrAssign : t -> Connection.t -> Quantity.t -> unit
  val insert : t -> Connection.t -> Quantity.t -> unit
  val at : t -> Connection.t -> Quantity.t
  val erase : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.t -> bool
  val keys : t -> ListConnection.t
  val values : t -> ListQuantity.t
  val items : t -> ListPairConnectionQuantity.t
  val coordinates : t -> MapConnectionQuantity.t
  val connections : t -> ListConnection.t
  val addition : t -> t -> t
  val subtraction : t -> t -> t
  val multiplication : t -> float -> t
  val division : t -> float -> t
  val negation : t -> t
  val setUnit : t -> SymbolUnit.t -> unit
end