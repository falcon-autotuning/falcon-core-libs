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
  val unit : string -> Symbolunit.t
  val selectByConnection : string -> Connection.t -> Listinterpretationcontext.t
  val selectByConnections : string -> Connections.t -> Listinterpretationcontext.t
  val selectByIndependentConnection : string -> Connection.t -> Listinterpretationcontext.t
  val selectByDependentConnection : string -> Connection.t -> Listinterpretationcontext.t
  val selectContexts : string -> Listconnection.t -> Listconnection.t -> Listinterpretationcontext.t
  val insertOrAssign : string -> Interpretationcontext.t -> string -> unit
  val insert : string -> Interpretationcontext.t -> string -> unit
  val at : string -> Interpretationcontext.t -> string
  val erase : string -> Interpretationcontext.t -> unit
  val size : string -> int
  val empty : string -> bool
  val clear : string -> unit
  val contains : string -> Interpretationcontext.t -> bool
  val keys : string -> Listinterpretationcontext.t
  val values : string -> string
  val items : string -> string
  val equal : string -> string -> bool
  val notEqual : string -> string -> bool
  val toJsonString : string -> string
end