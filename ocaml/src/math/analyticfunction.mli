open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AnalyticFunction *)
class type c_analyticfunction_t = object
  method raw : unit ptr
end

class c_analyticfunction : unit ptr -> c_analyticfunction_t

module AnalyticFunction : sig
  type t = c_analyticfunction

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> string -> t
  val identity : t
  val constant : float -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val labels : t -> string
  val evaluate : t -> Mapstringdouble.MapStringDouble.t -> float -> float
  val evaluateArraywise : t -> Mapstringdouble.MapStringDouble.t -> float -> float -> Farraydouble.FArrayDouble.t
end