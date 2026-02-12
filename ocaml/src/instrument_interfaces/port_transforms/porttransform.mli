open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PortTransform *)
class type c_porttransform_t = object
  method raw : unit ptr
end

class c_porttransform : unit ptr -> c_porttransform_t

module PortTransform : sig
  type t = c_porttransform

  val copy : t -> t
  val fromjson : string -> t
  val make : Instrumentport.InstrumentPort.t -> Analyticfunction.AnalyticFunction.t -> t
  val constantTransform : Instrumentport.InstrumentPort.t -> float -> t
  val identityTransform : Instrumentport.InstrumentPort.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val port : t -> Instrumentport.InstrumentPort.t
  val labels : t -> string
  val evaluate : t -> Mapstringdouble.MapStringDouble.t -> float -> float
  val evaluateArraywise : t -> Mapstringdouble.MapStringDouble.t -> float -> float -> Farraydouble.FArrayDouble.t
end