open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListBool *)
class type c_listbool_t = object
  method raw : unit ptr
end

class c_listbool : unit ptr -> c_listbool_t

module ListBool : sig
  type t = c_listbool

  val empty : t
  val copy : t -> t
  val allocate : int -> t
  val fillValue : int -> bool -> t
  val make : bool -> int -> t
  val fromjson : string -> t
  val pushBack : t -> bool -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> bool
  val items : t -> bool -> int -> int
  val contains : t -> bool -> bool
  val index : t -> bool -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end