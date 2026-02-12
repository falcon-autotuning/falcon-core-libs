open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPortTransform *)
class type c_listporttransform_t = object
  method raw : unit ptr
end

class c_listporttransform : unit ptr -> c_listporttransform_t

module ListPortTransform : sig
  type t = c_listporttransform

  val empty : t
  val copy : t -> t
  val fillValue : int -> Porttransform.t -> t
  val make : Porttransform.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Porttransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Porttransform.t
  val items : t -> Porttransform.t -> int -> int
  val contains : t -> Porttransform.t -> bool
  val index : t -> Porttransform.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end