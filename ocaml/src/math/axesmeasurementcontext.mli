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
  val make : Listmeasurementcontext.t -> t
  val fromjson : string -> t
  val pushBack : t -> Measurementcontext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Measurementcontext.t
  val items : t -> Measurementcontext.t -> int -> int
  val contains : t -> Measurementcontext.t -> bool
  val index : t -> Measurementcontext.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end