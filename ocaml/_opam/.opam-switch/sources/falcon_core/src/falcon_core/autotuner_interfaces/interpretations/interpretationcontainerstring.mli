open Ctypes

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

(** Opaque handle for InterpretationContainerString *)
class type c_interpretationcontainerstring_t = object
  method raw : unit ptr
end

class c_interpretationcontainerstring : unit ptr -> c_interpretationcontainerstring_t

module InterpretationContainerString : sig
  type t = c_interpretationcontainerstring

end

module InterpretationContainerString : sig
  type t = c_interpretationcontainerstring

  val make : string -> t
  val copy : string -> t
  val fromjson : string -> t
  val unit : string -> SymbolUnit.t
  val selectByConnection : string -> Connection.t -> ListInterpretationContext.t
  val selectByConnections : string -> Connections.t -> ListInterpretationContext.t
  val selectByIndependentConnection : string -> Connection.t -> ListInterpretationContext.t
  val selectByDependentConnection : string -> Connection.t -> ListInterpretationContext.t
  val selectContexts : string -> ListConnection.t -> ListConnection.t -> ListInterpretationContext.t
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