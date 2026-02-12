open Ctypes

open Falcon_core.Physics.Device_structures

(** Opaque handle for ListConnections *)
class type c_listconnections_t = object
  method raw : unit ptr
end

class c_listconnections : unit ptr -> c_listconnections_t

module ListConnections : sig
  type t = c_listconnections

end

module ListConnections : sig
  type t = c_listconnections

  val empty : t
  val copy : t -> t
  val fillValue : int -> Connections.t -> t
  val make : Connections.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Connections.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Connections.t
  val items : t -> Connections.t -> int -> int
  val contains : t -> Connections.t -> bool
  val index : t -> Connections.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end