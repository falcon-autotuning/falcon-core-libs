open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairInterpretationContextQuantity *)
class type c_listpairinterpretationcontextquantity_t = object
  method raw : unit ptr
end

class c_listpairinterpretationcontextquantity : unit ptr -> c_listpairinterpretationcontextquantity_t

module ListPairInterpretationContextQuantity : sig
  type t = c_listpairinterpretationcontextquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairinterpretationcontextquantity.PairInterpretationContextQuantity.t -> t
  val make : Pairinterpretationcontextquantity.PairInterpretationContextQuantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairinterpretationcontextquantity.PairInterpretationContextQuantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairinterpretationcontextquantity.PairInterpretationContextQuantity.t
  val items : t -> Pairinterpretationcontextquantity.PairInterpretationContextQuantity.t -> int -> int
  val contains : t -> Pairinterpretationcontextquantity.PairInterpretationContextQuantity.t -> bool
  val index : t -> Pairinterpretationcontextquantity.PairInterpretationContextQuantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end