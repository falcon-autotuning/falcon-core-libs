open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Config.Core

(** Opaque handle for VoltageConstraints *)
class type c_voltageconstraints_t = object
  method raw : unit ptr
end

class c_voltageconstraints : unit ptr -> c_voltageconstraints_t

module VoltageConstraints : sig
  type t = c_voltageconstraints

end

module VoltageConstraints : sig
  type t = c_voltageconstraints

  val copy : t -> t
  val fromjson : string -> t
  val make : Adjacency.t -> float -> PairDoubleDouble.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val matrix : t -> FArrayDouble.t
  val adjacency : t -> Adjacency.t
  val limits : t -> FArrayDouble.t
end