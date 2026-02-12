open Ctypes

open Falcon_core.Instrument_interfaces.Names

(** Opaque handle for ListInstrumentPort *)
class type c_listinstrumentport_t = object
  method raw : unit ptr
end

class c_listinstrumentport : unit ptr -> c_listinstrumentport_t

module ListInstrumentPort : sig
  type t = c_listinstrumentport

end

module ListInstrumentPort : sig
  type t = c_listinstrumentport

  val empty : t
  val copy : t -> t
  val fillValue : int -> InstrumentPort.t -> t
  val make : InstrumentPort.t -> int -> t
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