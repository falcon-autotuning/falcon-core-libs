open Ctypes

open Falcon_core.Communications.Messages
open Falcon_core.Communications.Messages

(** Opaque handle for PairMeasurementResponseMeasurementRequest *)
class type c_pairmeasurementresponsemeasurementrequest_t = object
  method raw : unit ptr
end

class c_pairmeasurementresponsemeasurementrequest : unit ptr -> c_pairmeasurementresponsemeasurementrequest_t

module PairMeasurementResponseMeasurementRequest : sig
  type t = c_pairmeasurementresponsemeasurementrequest

end

module PairMeasurementResponseMeasurementRequest : sig
  type t = c_pairmeasurementresponsemeasurementrequest

  val make : MeasurementResponse.t -> MeasurementRequest.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> MeasurementResponse.t
  val second : t -> MeasurementRequest.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end