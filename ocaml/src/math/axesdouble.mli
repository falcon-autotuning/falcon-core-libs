open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesDouble *)
class type c_axesdouble_t = object
  method raw : unit ptr
end

class c_axesdouble : unit ptr -> c_axesdouble_t

module AxesDouble : sig
  type t = c_axesdouble

  val empty : t
  val copy : t -> t
  val make : Listdouble.t -> t
  val fromjson : string -> t
  val pushBack : t -> float -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> float
  val items : t -> float -> int -> int
  val contains : t -> float -> bool
  val index : t -> float -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end