open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListFArrayDouble *)
class type c_listfarraydouble_t = object
  method raw : unit ptr
end

class c_listfarraydouble : unit ptr -> c_listfarraydouble_t

module ListFArrayDouble : sig
  type t = c_listfarraydouble

  val empty : t
  val copy : t -> t
  val fillValue : int -> Farraydouble.FArrayDouble.t -> t
  val make : Farraydouble.FArrayDouble.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Farraydouble.FArrayDouble.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Farraydouble.FArrayDouble.t
  val items : t -> Farraydouble.FArrayDouble.t -> int -> int
  val contains : t -> Farraydouble.FArrayDouble.t -> bool
  val index : t -> Farraydouble.FArrayDouble.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end