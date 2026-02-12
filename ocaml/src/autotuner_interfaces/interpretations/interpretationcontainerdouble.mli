open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for InterpretationContainerDouble *)
class type c_interpretationcontainerdouble_t = object
  method raw : unit ptr
end

class c_interpretationcontainerdouble : unit ptr -> c_interpretationcontainerdouble_t

module InterpretationContainerDouble : sig
  type t = c_interpretationcontainerdouble

  val make : Mapinterpretationcontextdouble.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val unit : t -> Symbolunit.t
  val selectByConnection : t -> Connection.t -> Listinterpretationcontext.t
  val selectByConnections : t -> Connections.t -> Listinterpretationcontext.t
  val selectByIndependentConnection : t -> Connection.t -> Listinterpretationcontext.t
  val selectByDependentConnection : t -> Connection.t -> Listinterpretationcontext.t
  val selectContexts : t -> Listconnection.t -> Listconnection.t -> Listinterpretationcontext.t
  val insertOrAssign : t -> Interpretationcontext.t -> float -> unit
  val insert : t -> Interpretationcontext.t -> float -> unit
  val at : t -> Interpretationcontext.t -> float
  val erase : t -> Interpretationcontext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Interpretationcontext.t -> bool
  val keys : t -> Listinterpretationcontext.t
  val values : t -> Listdouble.t
  val items : t -> Listpairinterpretationcontextdouble.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end