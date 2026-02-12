open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairConnectionPairQuantityQuantity *)
class type c_pairconnectionpairquantityquantity_t = object
  method raw : unit ptr
end

class c_pairconnectionpairquantityquantity : unit ptr -> c_pairconnectionpairquantityquantity_t

module PairConnectionPairQuantityQuantity : sig
  type t = c_pairconnectionpairquantityquantity

  val make : Connection.Connection.t -> Pairquantityquantity.PairQuantityQuantity.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Connection.Connection.t
  val second : t -> Pairquantityquantity.PairQuantityQuantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end