open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for DiscreteSpace *)
class type c_discretespace_t = object
  method raw : unit ptr
end

class c_discretespace : unit ptr -> c_discretespace_t

module DiscreteSpace : sig
  type t = c_discretespace

  val copy : t -> t
  val fromjson : string -> t
  val make : Unitspace.UnitSpace.t -> Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t -> Axesmapstringbool.AxesMapStringBool.t -> t
  val cartesianDiscreteSpace : Axesint.AxesInt.t -> Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t -> Axesmapstringbool.AxesMapStringBool.t -> Domain.Domain.t -> t
  val cartesianDiscreteSpace1d : int -> Coupledlabelleddomain.CoupledLabelledDomain.t -> Mapstringbool.MapStringBool.t -> Domain.Domain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val space : t -> Unitspace.UnitSpace.t
  val axes : t -> Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t
  val increasing : t -> Axesmapstringbool.AxesMapStringBool.t
  val knobs : t -> Ports.Ports.t
  val validateUnitSpaceDimensionalityMatchesKnobs : t -> unit
  val validateKnobUniqueness : t -> unit
  val getAxis : t -> Instrumentport.InstrumentPort.t -> int
  val getDomain : t -> Instrumentport.InstrumentPort.t -> Domain.Domain.t
  val getProjection : t -> Axesinstrumentport.AxesInstrumentPort.t -> Axeslabelledcontrolarray.AxesLabelledControlArray.t
end