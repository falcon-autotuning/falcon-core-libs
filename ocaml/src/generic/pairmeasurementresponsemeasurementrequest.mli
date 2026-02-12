open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairMeasurementResponseMeasurementRequest *)
class type c_pairmeasurementresponsemeasurementrequest_t = object
  method raw : unit ptr
end

class c_pairmeasurementresponsemeasurementrequest : unit ptr -> c_pairmeasurementresponsemeasurementrequest_t

module PairMeasurementResponseMeasurementRequest : sig
  type t = c_pairmeasurementresponsemeasurementrequest

  val make : Measurementresponse.MeasurementResponse.t -> Measurementrequest.MeasurementRequest.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Measurementresponse.MeasurementResponse.t
  val second : t -> Measurementrequest.MeasurementRequest.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end