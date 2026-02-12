open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairInterpretationContextString *)
class type c_pairinterpretationcontextstring_t = object
  method raw : unit ptr
end

class c_pairinterpretationcontextstring : unit ptr -> c_pairinterpretationcontextstring_t

module PairInterpretationContextString : sig
  type t = c_pairinterpretationcontextstring

  val make : Interpretationcontext.InterpretationContext.t -> string -> t
  val copy : string -> t
  val fromjson : string -> t
  val first : string -> Interpretationcontext.InterpretationContext.t
  val second : string -> string
  val equal : string -> string -> bool
  val notEqual : string -> string -> bool
  val toJsonString : string -> string
end