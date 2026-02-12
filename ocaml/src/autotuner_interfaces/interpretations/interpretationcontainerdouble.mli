open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for InterpretationContainerDouble *)
class type c_interpretationcontainerdouble_t = object
  method raw : unit ptr
end

class c_interpretationcontainerdouble : unit ptr -> c_interpretationcontainerdouble_t

module InterpretationContainerDouble : sig
  type t = c_interpretationcontainerdouble

  val make : Mapinterpretationcontextdouble.MapInterpretationContextDouble.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val unit : t -> Symbolunit.SymbolUnit.t
  val selectByConnection : t -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByConnections : t -> Connections.Connections.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByIndependentConnection : t -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByDependentConnection : t -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectContexts : t -> Listconnection.ListConnection.t -> Listconnection.ListConnection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val insertOrAssign : t -> Interpretationcontext.InterpretationContext.t -> float -> unit
  val insert : t -> Interpretationcontext.InterpretationContext.t -> float -> unit
  val at : t -> Interpretationcontext.InterpretationContext.t -> float
  val erase : t -> Interpretationcontext.InterpretationContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Interpretationcontext.InterpretationContext.t -> bool
  val keys : t -> Listinterpretationcontext.ListInterpretationContext.t
  val values : t -> Listdouble.ListDouble.t
  val items : t -> Listpairinterpretationcontextdouble.ListPairInterpretationContextDouble.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end