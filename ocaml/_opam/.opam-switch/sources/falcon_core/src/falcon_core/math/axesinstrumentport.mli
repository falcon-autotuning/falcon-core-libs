open Ctypes

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names

(** Opaque handle for AxesInstrumentPort *)
class type c_axesinstrumentport_t = object
  method raw : unit ptr
end

class c_axesinstrumentport : unit ptr -> c_axesinstrumentport_t

module AxesInstrumentPort : sig
  type t = c_axesinstrumentport

end

module AxesInstrumentPort : sig
  type t = c_axesinstrumentport

  val empty : t
  val copy : t -> t
  val make : ListInstrumentPort.t -> t
  val fromjson : string -> t
  val pushBack : t -> InstrumentPort.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> InstrumentPort.t
  val items : t -> InstrumentPort.t -> int -> int
  val contains : t -> InstrumentPort.t -> bool
  val index : t -> InstrumentPort.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end