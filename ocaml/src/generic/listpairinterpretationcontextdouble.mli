open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairInterpretationContextDouble *)
class type c_listpairinterpretationcontextdouble_t = object
  method raw : unit ptr
end

class c_listpairinterpretationcontextdouble : unit ptr -> c_listpairinterpretationcontextdouble_t

module ListPairInterpretationContextDouble : sig
  type t = c_listpairinterpretationcontextdouble

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairinterpretationcontextdouble.PairInterpretationContextDouble.t -> t
  val make : Pairinterpretationcontextdouble.PairInterpretationContextDouble.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairinterpretationcontextdouble.PairInterpretationContextDouble.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairinterpretationcontextdouble.PairInterpretationContextDouble.t
  val items : t -> Pairinterpretationcontextdouble.PairInterpretationContextDouble.t -> int -> int
  val contains : t -> Pairinterpretationcontextdouble.PairInterpretationContextDouble.t -> bool
  val index : t -> Pairinterpretationcontextdouble.PairInterpretationContextDouble.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end