open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapInterpretationContextQuantity *)
class type c_mapinterpretationcontextquantity_t = object
  method raw : unit ptr
end

class c_mapinterpretationcontextquantity : unit ptr -> c_mapinterpretationcontextquantity_t

module MapInterpretationContextQuantity : sig
  type t = c_mapinterpretationcontextquantity

  val empty : t
  val copy : t -> t
  val make : Pairinterpretationcontextquantity.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Interpretationcontext.t -> Quantity.t -> unit
  val insert : t -> Interpretationcontext.t -> Quantity.t -> unit
  val at : t -> Interpretationcontext.t -> Quantity.t
  val erase : t -> Interpretationcontext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Interpretationcontext.t -> bool
  val keys : t -> Listinterpretationcontext.t
  val values : t -> Listquantity.t
  val items : t -> Listpairinterpretationcontextquantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end