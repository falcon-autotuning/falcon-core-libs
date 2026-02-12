open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MeasurementResponse *)
class type c_measurementresponse_t = object
  method raw : unit ptr
end

class c_measurementresponse : unit ptr -> c_measurementresponse_t

module MeasurementResponse : sig
  type t = c_measurementresponse

  val copy : t -> t
  val fromjson : string -> t
  val make : Labelledarrayslabelledmeasuredarray.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val arrays : t -> Labelledarrayslabelledmeasuredarray.t
  val message : t -> string
end