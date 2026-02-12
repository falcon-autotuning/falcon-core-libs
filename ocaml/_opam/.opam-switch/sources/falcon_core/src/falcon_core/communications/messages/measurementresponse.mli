open Ctypes

open Falcon_core.Math.Arrays

(** Opaque handle for MeasurementResponse *)
class type c_measurementresponse_t = object
  method raw : unit ptr
end

class c_measurementresponse : unit ptr -> c_measurementresponse_t

module MeasurementResponse : sig
  type t = c_measurementresponse

end

module MeasurementResponse : sig
  type t = c_measurementresponse

  val copy : t -> t
  val fromjson : string -> t
  val make : LabelledArraysLabelledMeasuredArray.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val arrays : t -> LabelledArraysLabelledMeasuredArray.t
  val message : t -> string
end