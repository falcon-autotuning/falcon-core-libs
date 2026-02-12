open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListString *)
class type c_liststring_t = object
  method raw : unit ptr
end

class c_liststring : unit ptr -> c_liststring_t

module ListString : sig
  type t = c_liststring

  val empty : t
  val copy : string -> t
  val allocate : int -> t
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