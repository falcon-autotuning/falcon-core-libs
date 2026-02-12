open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for InstrumentPort *)
class type c_instrumentport_t = object
  method raw : unit ptr
end

class c_instrumentport : unit ptr -> c_instrumentport_t

module InstrumentPort : sig
  type t = c_instrumentport

  val copy : t -> t
  val fromjson : string -> t
  val port : string -> Connection.Connection.t -> string -> Symbolunit.SymbolUnit.t -> string -> t
  val knob : string -> Connection.Connection.t -> string -> Symbolunit.SymbolUnit.t -> string -> t
  val meter : string -> Connection.Connection.t -> string -> Symbolunit.SymbolUnit.t -> string -> t
  val timer : t
  val executionClock : t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val defaultName : t -> string
  val psuedoName : t -> Connection.Connection.t
  val instrumentType : t -> string
  val units : t -> Symbolunit.SymbolUnit.t
  val description : t -> string
  val instrumentFacingName : t -> string
  val isKnob : t -> bool
  val isMeter : t -> bool
  val isPort : t -> bool
end