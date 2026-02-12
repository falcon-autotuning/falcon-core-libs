open Ctypes

open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Math.Domains
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

(** Opaque handle for LabelledDomain *)
class type c_labelleddomain_t = object
  method raw : unit ptr
end

class c_labelleddomain : unit ptr -> c_labelleddomain_t

module LabelledDomain : sig
  type t = c_labelleddomain

end

module LabelledDomain : sig
  type t = c_labelleddomain

  val copy : t -> t
  val fromjson : string -> t
  val primitiveKnob : string -> float -> float -> Connection.t -> string -> bool -> bool -> SymbolUnit.t -> string -> t
  val primitiveMeter : string -> float -> float -> Connection.t -> string -> bool -> bool -> SymbolUnit.t -> string -> t
  val primitivePort : string -> float -> float -> Connection.t -> string -> bool -> bool -> SymbolUnit.t -> string -> t
  val fromPort : float -> float -> InstrumentPort.t -> bool -> bool -> t
  val fromPortAndDomain : InstrumentPort.t -> Domain.t -> t
  val fromDomain : Domain.t -> string -> Connection.t -> string -> SymbolUnit.t -> string -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val port : t -> InstrumentPort.t
  val domain : t -> Domain.t
  val matchingPort : t -> InstrumentPort.t -> bool
  val lesserBound : t -> float
  val greaterBound : t -> float
  val lesserBoundContained : t -> bool
  val greaterBoundContained : t -> bool
  val in_ : t -> float -> bool
  val range : t -> float
  val center : t -> float
  val intersection : t -> t -> t
  val union : t -> t -> t
  val isEmpty : t -> bool
  val containsDomain : t -> t -> bool
  val shift : t -> float -> t
  val scale : t -> float -> t
  val transform : t -> t -> float -> float
end