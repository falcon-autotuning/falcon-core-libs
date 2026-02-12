open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairChannelConnections *)
class type c_pairchannelconnections_t = object
  method raw : unit ptr
end

class c_pairchannelconnections : unit ptr -> c_pairchannelconnections_t

module PairChannelConnections : sig
  type t = c_pairchannelconnections

  val make : Channel.Channel.t -> Connections.Connections.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Channel.Channel.t
  val second : t -> Connections.Connections.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end