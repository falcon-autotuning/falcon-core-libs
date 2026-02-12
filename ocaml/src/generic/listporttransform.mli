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
  val fillValue : int -> Porttransform.PortTransform.t -> t
  val make : Porttransform.PortTransform.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Porttransform.PortTransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Porttransform.PortTransform.t
  val items : t -> Porttransform.PortTransform.t -> int -> int
  val contains : t -> Porttransform.PortTransform.t -> bool
  val index : t -> Porttransform.PortTransform.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end