open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairInterpretationContextString *)
class type c_listpairinterpretationcontextstring_t = object
  method raw : unit ptr
end

class c_listpairinterpretationcontextstring : unit ptr -> c_listpairinterpretationcontextstring_t

module ListPairInterpretationContextString : sig
  type t = c_listpairinterpretationcontextstring

  val empty : t
  val copy : string -> t
  val fillValue : int -> string -> t
  val make : string -> int -> t
  val fromjson : string -> t
  val pushBack : string -> string -> unit
  val size : string -> int
  val empty : string -> bool
  val eraseAt : string -> int -> unit
  val clear : string -> unit
  val at : string -> int -> string
  val items : string -> string -> int -> int
  val contains : string -> string -> bool
  val index : string -> string -> int
  val intersection : string -> string -> string
  val equal : string -> string -> bool
  val notEqual : string -> string -> bool
  val toJsonString : string -> string
end