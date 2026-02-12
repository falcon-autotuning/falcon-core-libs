open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Physics.Device_structures

(** Opaque handle for Ports *)
class type c_ports_t = object
  method raw : unit ptr
end

class c_ports : unit ptr -> c_ports_t

module Ports : sig
  type t = c_ports

end

module Ports : sig
  type t = c_ports

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : ListInstrumentPort.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val ports : t -> ListInstrumentPort.t
  val defaultNames : t -> string
  val getPsuedoNames : t -> ListConnection.t
  val _getRawNames : t -> string
  val _getInstrumentFacingNames : t -> string
  val _getPsuedonameMatchingPort : t -> Connection.t -> InstrumentPort.t
  val _getInstrumentTypeMatchingPort : t -> string -> InstrumentPort.t
  val isKnobs : t -> bool
  val isMeters : t -> bool
  val intersection : t -> t -> t
  val pushBack : t -> InstrumentPort.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> InstrumentPort.t
  val items : t -> string
  val contains : t -> InstrumentPort.t -> bool
  val index : t -> InstrumentPort.t -> int
end