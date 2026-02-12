open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesInstrumentPort *)
class type c_axesinstrumentport_t = object
  method raw : unit ptr
end

class c_axesinstrumentport : unit ptr -> c_axesinstrumentport_t

module AxesInstrumentPort : sig
  type t = c_axesinstrumentport

  val empty : t
  val copy : t -> t
  val make : Listinstrumentport.ListInstrumentPort.t -> t
  val fromjson : string -> t
  val pushBack : t -> Instrumentport.InstrumentPort.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Instrumentport.InstrumentPort.t
  val items : t -> Instrumentport.InstrumentPort.t -> int -> int
  val contains : t -> Instrumentport.InstrumentPort.t -> bool
  val index : t -> Instrumentport.InstrumentPort.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end