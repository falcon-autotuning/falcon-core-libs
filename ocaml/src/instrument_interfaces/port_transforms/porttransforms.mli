open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PortTransforms *)
class type c_porttransforms_t = object
  method raw : unit ptr
end

class c_porttransforms : unit ptr -> c_porttransforms_t

module PortTransforms : sig
  type t = c_porttransforms

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : Listporttransform.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val transforms : t -> Listporttransform.t
  val pushBack : t -> Porttransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Porttransform.t
  val items : t -> Listporttransform.t
  val contains : t -> Porttransform.t -> bool
  val index : t -> Porttransform.t -> int
  val intersection : t -> t -> t
end