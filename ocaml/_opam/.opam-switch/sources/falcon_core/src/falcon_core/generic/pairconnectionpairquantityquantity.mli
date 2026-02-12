open Ctypes

open Falcon_core.Generic
open Falcon_core.Physics.Device_structures

(** Opaque handle for PairConnectionPairQuantityQuantity *)
class type c_pairconnectionpairquantityquantity_t = object
  method raw : unit ptr
end

class c_pairconnectionpairquantityquantity : unit ptr -> c_pairconnectionpairquantityquantity_t

module PairConnectionPairQuantityQuantity : sig
  type t = c_pairconnectionpairquantityquantity

end

module PairConnectionPairQuantityQuantity : sig
  type t = c_pairconnectionpairquantityquantity

  val make : Connection.t -> PairQuantityQuantity.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Connection.t
  val second : t -> PairQuantityQuantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end