open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for InterpretationContainerQuantity *)
class type c_interpretationcontainerquantity_t = object
  method raw : unit ptr
end

class c_interpretationcontainerquantity : unit ptr -> c_interpretationcontainerquantity_t

module InterpretationContainerQuantity : sig
  type t = c_interpretationcontainerquantity

  val make : Mapinterpretationcontextquantity.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val unit : t -> Symbolunit.t
  val selectByConnection : t -> Connection.t -> Listinterpretationcontext.t
  val selectByConnections : t -> Connections.t -> Listinterpretationcontext.t
  val selectByIndependentConnection : t -> Connection.t -> Listinterpretationcontext.t
  val selectByDependentConnection : t -> Connection.t -> Listinterpretationcontext.t
  val selectContexts : t -> Listconnection.t -> Listconnection.t -> Listinterpretationcontext.t
  val insertOrAssign : t -> Interpretationcontext.t -> Quantity.t -> unit
  val insert : t -> Interpretationcontext.t -> Quantity.t -> unit
  val at : t -> Interpretationcontext.t -> Quantity.t
  val erase : t -> Interpretationcontext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Interpretationcontext.t -> bool
  val keys : t -> Listinterpretationcontext.t
  val values : t -> Listquantity.t
  val items : t -> Listpairinterpretationcontextquantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end