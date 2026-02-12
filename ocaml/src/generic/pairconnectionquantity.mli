open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairConnectionQuantity *)
class type c_pairconnectionquantity_t = object
  method raw : unit ptr
end

class c_pairconnectionquantity : unit ptr -> c_pairconnectionquantity_t

module PairConnectionQuantity : sig
  type t = c_pairconnectionquantity

  val make : Connection.Connection.t -> Quantity.Quantity.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Connection.Connection.t
  val second : t -> Quantity.Quantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end