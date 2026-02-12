open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesInt *)
class type c_axesint_t = object
  method raw : unit ptr
end

class c_axesint : unit ptr -> c_axesint_t

module AxesInt : sig
  type t = c_axesint

  val empty : t
  val copy : t -> t
  val make : Listint.t -> t
  val fromjson : string -> t
  val pushBack : t -> int -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> int
  val items : t -> int -> int -> int
  val contains : t -> int -> bool
  val index : t -> int -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end