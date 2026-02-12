open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListGname *)
class type c_listgname_t = object
  method raw : unit ptr
end

class c_listgname : unit ptr -> c_listgname_t

module ListGname : sig
  type t = c_listgname

  val empty : t
  val copy : t -> t
  val fillValue : int -> Gname.t -> t
  val make : Gname.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Gname.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Gname.t
  val items : t -> Gname.t -> int -> int
  val contains : t -> Gname.t -> bool
  val index : t -> Gname.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end