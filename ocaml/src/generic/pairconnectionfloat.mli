open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairConnectionFloat *)
class type c_pairconnectionfloat_t = object
  method raw : unit ptr
end

class c_pairconnectionfloat : unit ptr -> c_pairconnectionfloat_t

module PairConnectionFloat : sig
  type t = c_pairconnectionfloat

  val make : Connection.Connection.t -> float -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Connection.Connection.t
  val second : t -> float
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end