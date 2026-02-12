open Ctypes

open Falcon_core.Math

(** Opaque handle for PairQuantityQuantity *)
class type c_pairquantityquantity_t = object
  method raw : unit ptr
end

class c_pairquantityquantity : unit ptr -> c_pairquantityquantity_t

module PairQuantityQuantity : sig
  type t = c_pairquantityquantity

end

module PairQuantityQuantity : sig
  type t = c_pairquantityquantity

  val make : Quantity.t -> Quantity.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Quantity.t
  val second : t -> Quantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end