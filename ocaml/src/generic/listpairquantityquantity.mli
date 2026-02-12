open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairQuantityQuantity *)
class type c_listpairquantityquantity_t = object
  method raw : unit ptr
end

class c_listpairquantityquantity : unit ptr -> c_listpairquantityquantity_t

module ListPairQuantityQuantity : sig
  type t = c_listpairquantityquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairquantityquantity.PairQuantityQuantity.t -> t
  val make : Pairquantityquantity.PairQuantityQuantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairquantityquantity.PairQuantityQuantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairquantityquantity.PairQuantityQuantity.t
  val items : t -> Pairquantityquantity.PairQuantityQuantity.t -> int -> int
  val contains : t -> Pairquantityquantity.PairQuantityQuantity.t -> bool
  val index : t -> Pairquantityquantity.PairQuantityQuantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end