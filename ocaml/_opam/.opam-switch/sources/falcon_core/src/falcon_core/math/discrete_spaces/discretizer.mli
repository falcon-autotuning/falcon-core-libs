open Ctypes

open Falcon_core.Math.Domains

(** Opaque handle for Discretizer *)
class type c_discretizer_t = object
  method raw : unit ptr
end

class c_discretizer : unit ptr -> c_discretizer_t

module Discretizer : sig
  type t = c_discretizer

end

module Discretizer : sig
  type t = c_discretizer

  val copy : t -> t
  val fromjson : string -> t
  val cartesianDiscretizer : float -> t
  val polarDiscretizer : float -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val delta : t -> float
  val setDelta : t -> float -> unit
  val domain : t -> Domain.t
  val isCartesian : t -> bool
  val isPolar : t -> bool
end