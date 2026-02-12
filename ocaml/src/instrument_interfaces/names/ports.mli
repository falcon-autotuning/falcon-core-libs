open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Ports *)
class type c_ports_t = object
  method raw : unit ptr
end

class c_ports : unit ptr -> c_ports_t

module Ports : sig
  type t = c_ports

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : Listinstrumentport.ListInstrumentPort.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val ports : t -> Listinstrumentport.ListInstrumentPort.t
  val defaultNames : t -> string
  val getPsuedoNames : t -> Listconnection.ListConnection.t
  val _getRawNames : t -> string
  val _getInstrumentFacingNames : t -> string
  val _getPsuedonameMatchingPort : t -> Connection.Connection.t -> Instrumentport.InstrumentPort.t
  val _getInstrumentTypeMatchingPort : t -> string -> Instrumentport.InstrumentPort.t
  val isKnobs : t -> bool
  val isMeters : t -> bool
  val intersection : t -> t -> t
  val pushBack : t -> Instrumentport.InstrumentPort.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Instrumentport.InstrumentPort.t
  val items : t -> string
  val contains : t -> Instrumentport.InstrumentPort.t -> bool
  val index : t -> Instrumentport.InstrumentPort.t -> int
end