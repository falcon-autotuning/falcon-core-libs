open Ctypes

open Falcon_core.Physics.Device_structures

(** Opaque handle for ListConnection *)
class type c_listconnection_t = object
  method raw : unit ptr
end

class c_listconnection : unit ptr -> c_listconnection_t

module ListConnection : sig
  type t = c_listconnection

end

module ListConnection : sig
  type t = c_listconnection

  val empty : t
  val copy : t -> t
  val fillValue : int -> Connection.t -> t
  val make : Connection.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Connection.t
  val items : t -> Connection.t -> int -> int
  val contains : t -> Connection.t -> bool
  val index : t -> Connection.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end