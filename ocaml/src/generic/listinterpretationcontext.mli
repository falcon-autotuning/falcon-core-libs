open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListInterpretationContext *)
class type c_listinterpretationcontext_t = object
  method raw : unit ptr
end

class c_listinterpretationcontext : unit ptr -> c_listinterpretationcontext_t

module ListInterpretationContext : sig
  type t = c_listinterpretationcontext

  val empty : t
  val copy : t -> t
  val fillValue : int -> Interpretationcontext.t -> t
  val make : Interpretationcontext.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Interpretationcontext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Interpretationcontext.t
  val items : t -> Interpretationcontext.t -> int -> int
  val contains : t -> Interpretationcontext.t -> bool
  val index : t -> Interpretationcontext.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end