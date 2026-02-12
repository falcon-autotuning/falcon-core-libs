open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairConnectionQuantity *)
class type c_listpairconnectionquantity_t = object
  method raw : unit ptr
end

class c_listpairconnectionquantity : unit ptr -> c_listpairconnectionquantity_t

module ListPairConnectionQuantity : sig
  type t = c_listpairconnectionquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairconnectionquantity.t -> t
  val make : Pairconnectionquantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairconnectionquantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairconnectionquantity.t
  val items : t -> Pairconnectionquantity.t -> int -> int
  val contains : t -> Pairconnectionquantity.t -> bool
  val index : t -> Pairconnectionquantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end