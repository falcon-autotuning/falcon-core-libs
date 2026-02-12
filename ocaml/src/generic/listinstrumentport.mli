open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListInstrumentPort *)
class type c_listinstrumentport_t = object
  method raw : unit ptr
end

class c_listinstrumentport : unit ptr -> c_listinstrumentport_t

module ListInstrumentPort : sig
  type t = c_listinstrumentport

  val empty : t
  val copy : t -> t
  val fillValue : int -> Instrumentport.InstrumentPort.t -> t
  val make : Instrumentport.InstrumentPort.t -> int -> t
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