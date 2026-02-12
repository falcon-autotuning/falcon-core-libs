open Ctypes

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic

(** Opaque handle for MapInterpretationContextDouble *)
class type c_mapinterpretationcontextdouble_t = object
  method raw : unit ptr
end

class c_mapinterpretationcontextdouble : unit ptr -> c_mapinterpretationcontextdouble_t

module MapInterpretationContextDouble : sig
  type t = c_mapinterpretationcontextdouble

end

module MapInterpretationContextDouble : sig
  type t = c_mapinterpretationcontextdouble

  val empty : t
  val copy : t -> t
  val make : PairInterpretationContextDouble.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> InterpretationContext.t -> float -> unit
  val insert : t -> InterpretationContext.t -> float -> unit
  val at : t -> InterpretationContext.t -> float
  val erase : t -> InterpretationContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> InterpretationContext.t -> bool
  val keys : t -> ListInterpretationContext.t
  val values : t -> ListDouble.t
  val items : t -> ListPairInterpretationContextDouble.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end