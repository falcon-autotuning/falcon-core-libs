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
  val make : string -> string -> Listwaveform.t -> Ports.t -> Mapinstrumentportporttransform.t -> Labelleddomain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val measurementName : t -> string
  val getters : t -> Ports.t
  val waveforms : t -> Listwaveform.t
  val meterTransforms : t -> Mapinstrumentportporttransform.t
  val timeDomain : t -> Labelleddomain.t
  val message : t -> string
end