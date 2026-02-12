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
  val fillValue : int -> Interpretationcontext.InterpretationContext.t -> t
  val make : Interpretationcontext.InterpretationContext.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Interpretationcontext.InterpretationContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Interpretationcontext.InterpretationContext.t
  val items : t -> Interpretationcontext.InterpretationContext.t -> int -> int
  val contains : t -> Interpretationcontext.InterpretationContext.t -> bool
  val index : t -> Interpretationcontext.InterpretationContext.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end