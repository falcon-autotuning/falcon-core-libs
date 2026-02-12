open Ctypes

open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Physics.Device_structures

(** Opaque handle for MeasurementContext *)
class type c_measurementcontext_t = object
  method raw : unit ptr
end

class c_measurementcontext : unit ptr -> c_measurementcontext_t

module MeasurementContext : sig
  type t = c_measurementcontext

end

module MeasurementContext : sig
  type t = c_measurementcontext

  val copy : t -> t
  val fromjson : string -> t
  val make : Connection.t -> string -> t
  val fromPort : InstrumentPort.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val connection : t -> Connection.t
  val instrumentType : t -> string
end