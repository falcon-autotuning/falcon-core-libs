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
  val make : Adjacency.Adjacency.t -> float -> Pairdoubledouble.PairDoubleDouble.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val matrix : t -> Farraydouble.FArrayDouble.t
  val adjacency : t -> Adjacency.Adjacency.t
  val limits : t -> Farraydouble.FArrayDouble.t
end