open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairConnectionPairQuantityQuantity *)
class type c_listpairconnectionpairquantityquantity_t = object
  method raw : unit ptr
end

class c_listpairconnectionpairquantityquantity : unit ptr -> c_listpairconnectionpairquantityquantity_t

module ListPairConnectionPairQuantityQuantity : sig
  type t = c_listpairconnectionpairquantityquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairconnectionpairquantityquantity.PairConnectionPairQuantityQuantity.t -> t
  val make : Pairconnectionpairquantityquantity.PairConnectionPairQuantityQuantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairconnectionpairquantityquantity.PairConnectionPairQuantityQuantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairconnectionpairquantityquantity.PairConnectionPairQuantityQuantity.t
  val items : t -> Pairconnectionpairquantityquantity.PairConnectionPairQuantityQuantity.t -> int -> int
  val contains : t -> Pairconnectionpairquantityquantity.PairConnectionPairQuantityQuantity.t -> bool
  val index : t -> Pairconnectionpairquantityquantity.PairConnectionPairQuantityQuantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end