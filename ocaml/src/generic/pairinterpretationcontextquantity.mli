open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairInterpretationContextQuantity *)
class type c_pairinterpretationcontextquantity_t = object
  method raw : unit ptr
end

class c_pairinterpretationcontextquantity : unit ptr -> c_pairinterpretationcontextquantity_t

module PairInterpretationContextQuantity : sig
  type t = c_pairinterpretationcontextquantity

  val make : Interpretationcontext.t -> Quantity.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Interpretationcontext.t
  val second : t -> Quantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end