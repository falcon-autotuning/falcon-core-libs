open Ctypes

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math.Domains
open Falcon_core.Math.Domains
open Falcon_core.Math

(** Opaque handle for DiscreteSpace *)
class type c_discretespace_t = object
  method raw : unit ptr
end

class c_discretespace : unit ptr -> c_discretespace_t

module DiscreteSpace : sig
  type t = c_discretespace

end

module DiscreteSpace : sig
  type t = c_discretespace

  val copy : t -> t
  val fromjson : string -> t
  val make : UnitSpace.t -> AxesCoupledLabelledDomain.t -> AxesMapStringBool.t -> t
  val cartesianDiscreteSpace : AxesInt.t -> AxesCoupledLabelledDomain.t -> AxesMapStringBool.t -> Domain.t -> t
  val cartesianDiscreteSpace1d : int -> CoupledLabelledDomain.t -> MapStringBool.t -> Domain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val space : t -> UnitSpace.t
  val axes : t -> AxesCoupledLabelledDomain.t
  val increasing : t -> AxesMapStringBool.t
  val knobs : t -> Ports.t
  val validateUnitSpaceDimensionalityMatchesKnobs : t -> unit
  val validateKnobUniqueness : t -> unit
  val getAxis : t -> InstrumentPort.t -> int
  val getDomain : t -> InstrumentPort.t -> Domain.t
  val getProjection : t -> AxesInstrumentPort.t -> AxesLabelledControlArray.t
end