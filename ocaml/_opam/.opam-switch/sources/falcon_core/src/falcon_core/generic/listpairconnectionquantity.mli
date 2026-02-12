open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairConnectionQuantity *)
class type c_listpairconnectionquantity_t = object
  method raw : unit ptr
end

class c_listpairconnectionquantity : unit ptr -> c_listpairconnectionquantity_t

module ListPairConnectionQuantity : sig
  type t = c_listpairconnectionquantity

end

module ListPairConnectionQuantity : sig
  type t = c_listpairconnectionquantity

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairConnectionQuantity.t -> t
  val make : PairConnectionQuantity.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairConnectionQuantity.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairConnectionQuantity.t
  val items : t -> PairConnectionQuantity.t -> int -> int
  val contains : t -> PairConnectionQuantity.t -> bool
  val index : t -> PairConnectionQuantity.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end