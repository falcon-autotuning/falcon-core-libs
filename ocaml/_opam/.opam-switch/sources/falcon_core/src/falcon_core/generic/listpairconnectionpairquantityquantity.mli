open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairConnectionPairQuantityQuantity *)
class type c_listpairconnectionpairquantityquantity_t = object
  method raw : unit ptr
end

class c_listpairconnectionpairquantityquantity : unit ptr -> c_listpairconnectionpairquantityquantity_t

module ListPairConnectionPairQuantityQuantity : sig
  type t = c_listpairconnectionpairquantityquantity

end

module ListPairConnectionPairQuantityQuantity : sig
  type t = c_listpairconnectionpairquantityquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairConnectionPairQuantityQuantity.t -> t
  val make : PairConnectionPairQuantityQuantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairConnectionPairQuantityQuantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairConnectionPairQuantityQuantity.t
  val items : t -> PairConnectionPairQuantityQuantity.t -> int -> int
  val contains : t -> PairConnectionPairQuantityQuantity.t -> bool
  val index : t -> PairConnectionPairQuantityQuantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end