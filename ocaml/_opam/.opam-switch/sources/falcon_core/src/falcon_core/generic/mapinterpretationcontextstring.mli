open Ctypes

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Generic

(** Opaque handle for MapInterpretationContextString *)
class type c_mapinterpretationcontextstring_t = object
  method raw : unit ptr
end

class c_mapinterpretationcontextstring : unit ptr -> c_mapinterpretationcontextstring_t

module MapInterpretationContextString : sig
  type t = c_mapinterpretationcontextstring

end

module MapInterpretationContextString : sig
  type t = c_mapinterpretationcontextstring

  val empty : t
  val copy : string -> t
  val make : string -> int -> t
  val fromjson : string -> t
  val insertOrAssign : string -> InterpretationContext.t -> string -> unit
  val insert : string -> InterpretationContext.t -> string -> unit
  val at : string -> InterpretationContext.t -> string
  val erase : string -> InterpretationContext.t -> unit
  val size : string -> int
  val empty : string -> bool
  val clear : string -> unit
  val contains : string -> InterpretationContext.t -> bool
  val keys : string -> ListInterpretationContext.t
  val values : string -> string
  val items : string -> string
  val equal : string -> string -> bool
  val notEqual : string -> string -> bool
  val toJsonString : string -> string
end