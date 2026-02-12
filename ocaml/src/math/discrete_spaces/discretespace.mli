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
  val make : Unitspace.t -> Axescoupledlabelleddomain.t -> Axesmapstringbool.t -> t
  val cartesianDiscreteSpace : Axesint.t -> Axescoupledlabelleddomain.t -> Axesmapstringbool.t -> Domain.t -> t
  val cartesianDiscreteSpace1d : int -> Coupledlabelleddomain.t -> Mapstringbool.t -> Domain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val space : t -> Unitspace.t
  val axes : t -> Axescoupledlabelleddomain.t
  val increasing : t -> Axesmapstringbool.t
  val knobs : t -> Ports.t
  val validateUnitSpaceDimensionalityMatchesKnobs : t -> unit
  val validateKnobUniqueness : t -> unit
  val getAxis : t -> Instrumentport.t -> int
  val getDomain : t -> Instrumentport.t -> Domain.t
  val getProjection : t -> Axesinstrumentport.t -> Axeslabelledcontrolarray.t
end