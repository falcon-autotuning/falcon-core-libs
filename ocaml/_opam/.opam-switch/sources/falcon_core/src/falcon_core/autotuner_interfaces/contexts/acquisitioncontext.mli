open Ctypes

open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

(** Opaque handle for AcquisitionContext *)
class type c_acquisitioncontext_t = object
  method raw : unit ptr
end

class c_acquisitioncontext : unit ptr -> c_acquisitioncontext_t

module AcquisitionContext : sig
  type t = c_acquisitioncontext

end

module AcquisitionContext : sig
  type t = c_acquisitioncontext

  val copy : t -> t
  val fromjson : string -> t
  val make : Connection.t -> string -> SymbolUnit.t -> t
  val fromPort : InstrumentPort.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val connection : t -> Connection.t
  val instrumentType : t -> string
  val units : t -> SymbolUnit.t
  val divisionUnit : t -> SymbolUnit.t -> t
  val division : t -> t -> t
  val matchConnection : t -> Connection.t -> bool
  val matchInstrumentType : t -> string -> bool
end