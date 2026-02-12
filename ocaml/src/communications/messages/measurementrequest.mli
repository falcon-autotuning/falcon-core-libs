open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MeasurementRequest *)
class type c_measurementrequest_t = object
  method raw : unit ptr
end

class c_measurementrequest : unit ptr -> c_measurementrequest_t

module MeasurementRequest : sig
  type t = c_measurementrequest

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> string -> Listwaveform.ListWaveform.t -> Ports.Ports.t -> Mapinstrumentportporttransform.MapInstrumentPortPortTransform.t -> Labelleddomain.LabelledDomain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val measurementName : t -> string
  val getters : t -> Ports.Ports.t
  val waveforms : t -> Listwaveform.ListWaveform.t
  val meterTransforms : t -> Mapinstrumentportporttransform.MapInstrumentPortPortTransform.t
  val timeDomain : t -> Labelleddomain.LabelledDomain.t
  val message : t -> string
end