open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListGroup *)
class type c_listgroup_t = object
  method raw : unit ptr
end

class c_listgroup : unit ptr -> c_listgroup_t

module ListGroup : sig
  type t = c_listgroup

  val empty : t
  val copy : t -> t
  val fillValue : int -> Group.Group.t -> t
  val make : Group.Group.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Group.Group.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Group.Group.t
  val items : t -> Group.Group.t -> int -> int
  val contains : t -> Group.Group.t -> bool
  val index : t -> Group.Group.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end