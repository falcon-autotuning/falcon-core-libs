open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AcquisitionContext *)
class type c_acquisitioncontext_t = object
  method raw : unit ptr
end

class c_acquisitioncontext : unit ptr -> c_acquisitioncontext_t

module AcquisitionContext : sig
  type t = c_acquisitioncontext

  val copy : t -> t
  val fromjson : string -> t
  val make : Connection.Connection.t -> string -> Symbolunit.SymbolUnit.t -> t
  val fromPort : Instrumentport.InstrumentPort.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val connection : t -> Connection.Connection.t
  val instrumentType : t -> string
  val units : t -> Symbolunit.SymbolUnit.t
  val divisionUnit : t -> Symbolunit.SymbolUnit.t -> t
  val division : t -> t -> t
  val matchConnection : t -> Connection.Connection.t -> bool
  val matchInstrumentType : t -> string -> bool
end