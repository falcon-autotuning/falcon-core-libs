open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListConnection *)
class type c_listconnection_t = object
  method raw : unit ptr
end

class c_listconnection : unit ptr -> c_listconnection_t

module ListConnection : sig
  type t = c_listconnection

  val empty : t
  val copy : t -> t
  val fillValue : int -> Connection.Connection.t -> t
  val make : Connection.Connection.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Connection.Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Connection.Connection.t
  val items : t -> Connection.Connection.t -> int -> int
  val contains : t -> Connection.Connection.t -> bool
  val index : t -> Connection.Connection.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end