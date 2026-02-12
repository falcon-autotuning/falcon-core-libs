open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesMeasurementContext *)
class type c_axesmeasurementcontext_t = object
  method raw : unit ptr
end

class c_axesmeasurementcontext : unit ptr -> c_axesmeasurementcontext_t

module AxesMeasurementContext : sig
  type t = c_axesmeasurementcontext

  val empty : t
  val copy : t -> t
  val make : Listmeasurementcontext.ListMeasurementContext.t -> t
  val fromjson : string -> t
  val pushBack : t -> Measurementcontext.MeasurementContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Measurementcontext.MeasurementContext.t
  val items : t -> Measurementcontext.MeasurementContext.t -> int -> int
  val contains : t -> Measurementcontext.MeasurementContext.t -> bool
  val index : t -> Measurementcontext.MeasurementContext.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end