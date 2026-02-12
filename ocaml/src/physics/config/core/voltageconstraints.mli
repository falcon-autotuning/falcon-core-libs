open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for VoltageConstraints *)
class type c_voltageconstraints_t = object
  method raw : unit ptr
end

class c_voltageconstraints : unit ptr -> c_voltageconstraints_t

module VoltageConstraints : sig
  type t = c_voltageconstraints

  val copy : t -> t
  val fromjson : string -> t
  val make : Adjacency.t -> float -> Pairdoubledouble.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val matrix : t -> Farraydouble.t
  val adjacency : t -> Adjacency.t
  val limits : t -> Farraydouble.t
end