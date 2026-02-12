open Ctypes

open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Instrument_interfaces.Port_transforms

(** Opaque handle for PairInstrumentPortPortTransform *)
class type c_pairinstrumentportporttransform_t = object
  method raw : unit ptr
end

class c_pairinstrumentportporttransform : unit ptr -> c_pairinstrumentportporttransform_t

module PairInstrumentPortPortTransform : sig
  type t = c_pairinstrumentportporttransform

end

module PairInstrumentPortPortTransform : sig
  type t = c_pairinstrumentportporttransform

  val make : InstrumentPort.t -> PortTransform.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> InstrumentPort.t
  val second : t -> PortTransform.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end