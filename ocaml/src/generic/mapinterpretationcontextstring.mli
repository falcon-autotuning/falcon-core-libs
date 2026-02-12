open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapInterpretationContextString *)
class type c_mapinterpretationcontextstring_t = object
  method raw : unit ptr
end

class c_mapinterpretationcontextstring : unit ptr -> c_mapinterpretationcontextstring_t

module MapInterpretationContextString : sig
  type t = c_mapinterpretationcontextstring

  val empty : t
  val copy : string -> t
  val make : string -> int -> t
  val fromjson : string -> t
  val insertOrAssign : string -> Interpretationcontext.t -> string -> unit
  val insert : string -> Interpretationcontext.t -> string -> unit
  val at : string -> Interpretationcontext.t -> string
  val erase : string -> Interpretationcontext.t -> unit
  val size : string -> int
  val empty : string -> bool
  val clear : string -> unit
  val contains : string -> Interpretationcontext.t -> bool
  val keys : string -> Listinterpretationcontext.t
  val values : string -> string
  val items : string -> string
  val equal : string -> string -> bool
  val notEqual : string -> string -> bool
  val toJsonString : string -> string
end