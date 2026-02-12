open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairInstrumentPortPortTransform *)
class type c_pairinstrumentportporttransform_t = object
  method raw : unit ptr
end

class c_pairinstrumentportporttransform : unit ptr -> c_pairinstrumentportporttransform_t

module PairInstrumentPortPortTransform : sig
  type t = c_pairinstrumentportporttransform

  val make : Instrumentport.InstrumentPort.t -> Porttransform.PortTransform.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Instrumentport.InstrumentPort.t
  val second : t -> Porttransform.PortTransform.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end