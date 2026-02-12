open Ctypes

open Falcon_core.Physics.Device_structures

(** Opaque handle for PairConnectionDouble *)
class type c_pairconnectiondouble_t = object
  method raw : unit ptr
end

class c_pairconnectiondouble : unit ptr -> c_pairconnectiondouble_t

module PairConnectionDouble : sig
  type t = c_pairconnectiondouble

end

module PairConnectionDouble : sig
  type t = c_pairconnectiondouble

  val make : Connection.t -> float -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Connection.t
  val second : t -> float
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end