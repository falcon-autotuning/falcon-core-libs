open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapChannelConnections *)
class type c_mapchannelconnections_t = object
  method raw : unit ptr
end

class c_mapchannelconnections : unit ptr -> c_mapchannelconnections_t

module MapChannelConnections : sig
  type t = c_mapchannelconnections

  val empty : t
  val copy : t -> t
  val make : Pairchannelconnections.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Channel.t -> Connections.t -> unit
  val insert : t -> Channel.t -> Connections.t -> unit
  val at : t -> Channel.t -> Connections.t
  val erase : t -> Channel.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Channel.t -> bool
  val keys : t -> Listchannel.t
  val values : t -> Listconnections.t
  val items : t -> Listpairchannelconnections.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end