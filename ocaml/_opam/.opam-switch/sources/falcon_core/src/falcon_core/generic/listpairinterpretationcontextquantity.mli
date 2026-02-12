open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairInterpretationContextQuantity *)
class type c_listpairinterpretationcontextquantity_t = object
  method raw : unit ptr
end

class c_listpairinterpretationcontextquantity : unit ptr -> c_listpairinterpretationcontextquantity_t

module ListPairInterpretationContextQuantity : sig
  type t = c_listpairinterpretationcontextquantity

end

module ListPairInterpretationContextQuantity : sig
  type t = c_listpairinterpretationcontextquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairInterpretationContextQuantity.t -> t
  val make : PairInterpretationContextQuantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairInterpretationContextQuantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairInterpretationContextQuantity.t
  val items : t -> PairInterpretationContextQuantity.t -> int -> int
  val contains : t -> PairInterpretationContextQuantity.t -> bool
  val index : t -> PairInterpretationContextQuantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end