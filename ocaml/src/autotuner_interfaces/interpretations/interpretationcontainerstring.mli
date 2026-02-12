open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for InterpretationContainerString *)
class type c_interpretationcontainerstring_t = object
  method raw : unit ptr
end

class c_interpretationcontainerstring : unit ptr -> c_interpretationcontainerstring_t

module InterpretationContainerString : sig
  type t = c_interpretationcontainerstring

  val make : string -> t
  val copy : string -> t
  val fromjson : string -> t
  val unit : string -> Symbolunit.SymbolUnit.t
  val selectByConnection : string -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByConnections : string -> Connections.Connections.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByIndependentConnection : string -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByDependentConnection : string -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectContexts : string -> Listconnection.ListConnection.t -> Listconnection.ListConnection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val insertOrAssign : string -> Interpretationcontext.InterpretationContext.t -> string -> unit
  val insert : string -> Interpretationcontext.InterpretationContext.t -> string -> unit
  val at : string -> Interpretationcontext.InterpretationContext.t -> string
  val erase : string -> Interpretationcontext.InterpretationContext.t -> unit
  val size : string -> int
  val empty : string -> bool
  val clear : string -> unit
  val contains : string -> Interpretationcontext.InterpretationContext.t -> bool
  val keys : string -> Listinterpretationcontext.ListInterpretationContext.t
  val values : string -> string
  val items : string -> string
  val equal : string -> string -> bool
  val notEqual : string -> string -> bool
  val toJsonString : string -> string
end