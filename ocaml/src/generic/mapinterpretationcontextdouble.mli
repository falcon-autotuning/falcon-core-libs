open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapInterpretationContextDouble *)
class type c_mapinterpretationcontextdouble_t = object
  method raw : unit ptr
end

class c_mapinterpretationcontextdouble : unit ptr -> c_mapinterpretationcontextdouble_t

module MapInterpretationContextDouble : sig
  type t = c_mapinterpretationcontextdouble

  val empty : t
  val copy : t -> t
  val make : Pairinterpretationcontextdouble.PairInterpretationContextDouble.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Interpretationcontext.InterpretationContext.t -> float -> unit
  val insert : t -> Interpretationcontext.InterpretationContext.t -> float -> unit
  val at : t -> Interpretationcontext.InterpretationContext.t -> float
  val erase : t -> Interpretationcontext.InterpretationContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Interpretationcontext.InterpretationContext.t -> bool
  val keys : t -> Listinterpretationcontext.ListInterpretationContext.t
  val values : t -> Listdouble.ListDouble.t
  val items : t -> Listpairinterpretationcontextdouble.ListPairInterpretationContextDouble.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end