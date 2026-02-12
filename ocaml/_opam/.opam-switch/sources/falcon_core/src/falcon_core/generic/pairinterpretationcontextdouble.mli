open Ctypes

open Falcon_core.Autotuner_interfaces.Interpretations

(** Opaque handle for PairInterpretationContextDouble *)
class type c_pairinterpretationcontextdouble_t = object
  method raw : unit ptr
end

class c_pairinterpretationcontextdouble : unit ptr -> c_pairinterpretationcontextdouble_t

module PairInterpretationContextDouble : sig
  type t = c_pairinterpretationcontextdouble

end

module PairInterpretationContextDouble : sig
  type t = c_pairinterpretationcontextdouble

  val make : InterpretationContext.t -> float -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> InterpretationContext.t
  val second : t -> float
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end