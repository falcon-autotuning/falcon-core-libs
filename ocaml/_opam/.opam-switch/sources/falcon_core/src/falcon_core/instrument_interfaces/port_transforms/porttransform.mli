open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Math

(** Opaque handle for PortTransform *)
class type c_porttransform_t = object
  method raw : unit ptr
end

class c_porttransform : unit ptr -> c_porttransform_t

module PortTransform : sig
  type t = c_porttransform

end

module PortTransform : sig
  type t = c_porttransform

  val copy : t -> t
  val fromjson : string -> t
  val make : InstrumentPort.t -> AnalyticFunction.t -> t
  val constantTransform : InstrumentPort.t -> float -> t
  val identityTransform : InstrumentPort.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val port : t -> InstrumentPort.t
  val labels : t -> string
  val evaluate : t -> MapStringDouble.t -> float -> float
  val evaluateArraywise : t -> MapStringDouble.t -> float -> float -> FArrayDouble.t
end