open Ctypes

open Falcon_core.Autotuner_interfaces.Contexts

(** Opaque handle for ListMeasurementContext *)
class type c_listmeasurementcontext_t = object
  method raw : unit ptr
end

class c_listmeasurementcontext : unit ptr -> c_listmeasurementcontext_t

module ListMeasurementContext : sig
  type t = c_listmeasurementcontext

end

module ListMeasurementContext : sig
  type t = c_listmeasurementcontext

  val empty : t
  val copy : t -> t
  val fillValue : int -> MeasurementContext.t -> t
  val make : MeasurementContext.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> MeasurementContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> MeasurementContext.t
  val items : t -> MeasurementContext.t -> int -> int
  val contains : t -> MeasurementContext.t -> bool
  val index : t -> MeasurementContext.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end