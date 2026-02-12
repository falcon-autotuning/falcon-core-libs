open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairQuantityQuantity *)
class type c_listpairquantityquantity_t = object
  method raw : unit ptr
end

class c_listpairquantityquantity : unit ptr -> c_listpairquantityquantity_t

module ListPairQuantityQuantity : sig
  type t = c_listpairquantityquantity

end

module ListPairQuantityQuantity : sig
  type t = c_listpairquantityquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairQuantityQuantity.t -> t
  val make : PairQuantityQuantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairQuantityQuantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairQuantityQuantity.t
  val items : t -> PairQuantityQuantity.t -> int -> int
  val contains : t -> PairQuantityQuantity.t -> bool
  val index : t -> PairQuantityQuantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end