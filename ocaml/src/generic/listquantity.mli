open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListQuantity *)
class type c_listquantity_t = object
  method raw : unit ptr
end

class c_listquantity : unit ptr -> c_listquantity_t

module ListQuantity : sig
  type t = c_listquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> Quantity.Quantity.t -> t
  val make : Quantity.Quantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Quantity.Quantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Quantity.Quantity.t
  val items : t -> Quantity.Quantity.t -> int -> int
  val contains : t -> Quantity.Quantity.t -> bool
  val index : t -> Quantity.Quantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end