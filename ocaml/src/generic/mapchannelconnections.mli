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
  val make : Pairchannelconnections.PairChannelConnections.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Channel.Channel.t -> Connections.Connections.t -> unit
  val insert : t -> Channel.Channel.t -> Connections.Connections.t -> unit
  val at : t -> Channel.Channel.t -> Connections.Connections.t
  val erase : t -> Channel.Channel.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Channel.Channel.t -> bool
  val keys : t -> Listchannel.ListChannel.t
  val values : t -> Listconnections.ListConnections.t
  val items : t -> Listpairchannelconnections.ListPairChannelConnections.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end