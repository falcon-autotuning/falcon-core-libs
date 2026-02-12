open Ctypes

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

(** Opaque handle for InterpretationContainerDouble *)
class type c_interpretationcontainerdouble_t = object
  method raw : unit ptr
end

class c_interpretationcontainerdouble : unit ptr -> c_interpretationcontainerdouble_t

module InterpretationContainerDouble : sig
  type t = c_interpretationcontainerdouble

end

module InterpretationContainerDouble : sig
  type t = c_interpretationcontainerdouble

  val make : MapInterpretationContextDouble.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val unit : t -> SymbolUnit.t
  val selectByConnection : t -> Connection.t -> ListInterpretationContext.t
  val selectByConnections : t -> Connections.t -> ListInterpretationContext.t
  val selectByIndependentConnection : t -> Connection.t -> ListInterpretationContext.t
  val selectByDependentConnection : t -> Connection.t -> ListInterpretationContext.t
  val selectContexts : t -> ListConnection.t -> ListConnection.t -> ListInterpretationContext.t
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