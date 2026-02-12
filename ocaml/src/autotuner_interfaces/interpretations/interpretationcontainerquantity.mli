open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for InterpretationContainerQuantity *)
class type c_interpretationcontainerquantity_t = object
  method raw : unit ptr
end

class c_interpretationcontainerquantity : unit ptr -> c_interpretationcontainerquantity_t

module InterpretationContainerQuantity : sig
  type t = c_interpretationcontainerquantity

  val make : Mapinterpretationcontextquantity.MapInterpretationContextQuantity.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val unit : t -> Symbolunit.SymbolUnit.t
  val selectByConnection : t -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByConnections : t -> Connections.Connections.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByIndependentConnection : t -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectByDependentConnection : t -> Connection.Connection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val selectContexts : t -> Listconnection.ListConnection.t -> Listconnection.ListConnection.t -> Listinterpretationcontext.ListInterpretationContext.t
  val insertOrAssign : t -> Interpretationcontext.InterpretationContext.t -> Quantity.Quantity.t -> unit
  val insert : t -> Interpretationcontext.InterpretationContext.t -> Quantity.Quantity.t -> unit
  val at : t -> Interpretationcontext.InterpretationContext.t -> Quantity.Quantity.t
  val erase : t -> Interpretationcontext.InterpretationContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Interpretationcontext.InterpretationContext.t -> bool
  val keys : t -> Listinterpretationcontext.ListInterpretationContext.t
  val values : t -> Listquantity.ListQuantity.t
  val items : t -> Listpairinterpretationcontextquantity.ListPairInterpretationContextQuantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end