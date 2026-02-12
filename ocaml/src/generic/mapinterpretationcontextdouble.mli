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
  val make : Pairinterpretationcontextdouble.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Interpretationcontext.t -> float -> unit
  val insert : t -> Interpretationcontext.t -> float -> unit
  val at : t -> Interpretationcontext.t -> float
  val erase : t -> Interpretationcontext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Interpretationcontext.t -> bool
  val keys : t -> Listinterpretationcontext.t
  val values : t -> Listdouble.t
  val items : t -> Listpairinterpretationcontextdouble.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end