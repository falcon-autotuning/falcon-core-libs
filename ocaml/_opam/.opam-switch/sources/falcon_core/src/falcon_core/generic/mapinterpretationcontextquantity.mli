open Ctypes

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math

(** Opaque handle for MapInterpretationContextQuantity *)
class type c_mapinterpretationcontextquantity_t = object
  method raw : unit ptr
end

class c_mapinterpretationcontextquantity : unit ptr -> c_mapinterpretationcontextquantity_t

module MapInterpretationContextQuantity : sig
  type t = c_mapinterpretationcontextquantity

end

module MapInterpretationContextQuantity : sig
  type t = c_mapinterpretationcontextquantity

  val empty : t
  val copy : t -> t
  val make : PairInterpretationContextQuantity.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> InterpretationContext.t -> Quantity.t -> unit
  val insert : t -> InterpretationContext.t -> Quantity.t -> unit
  val at : t -> InterpretationContext.t -> Quantity.t
  val erase : t -> InterpretationContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> InterpretationContext.t -> bool
  val keys : t -> ListInterpretationContext.t
  val values : t -> ListQuantity.t
  val items : t -> ListPairInterpretationContextQuantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end