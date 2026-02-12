open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Math.Domains

(** Opaque handle for MeasurementRequest *)
class type c_measurementrequest_t = object
  method raw : unit ptr
end

class c_measurementrequest : unit ptr -> c_measurementrequest_t

module MeasurementRequest : sig
  type t = c_measurementrequest

end

module MeasurementRequest : sig
  type t = c_measurementrequest

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> string -> ListWaveform.t -> Ports.t -> MapInstrumentPortPortTransform.t -> LabelledDomain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val measurementName : t -> string
  val getters : t -> Ports.t
  val waveforms : t -> ListWaveform.t
  val meterTransforms : t -> MapInstrumentPortPortTransform.t
  val timeDomain : t -> LabelledDomain.t
  val message : t -> string
end