open Ctypes

open Falcon_core.Autotuner_interfaces.Names
open Falcon_core.Physics.Device_structures

(** Opaque handle for PairChannelConnections *)
class type c_pairchannelconnections_t = object
  method raw : unit ptr
end

class c_pairchannelconnections : unit ptr -> c_pairchannelconnections_t

module PairChannelConnections : sig
  type t = c_pairchannelconnections

end

module PairChannelConnections : sig
  type t = c_pairchannelconnections

  val make : Channel.t -> Connections.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Channel.t
  val second : t -> Connections.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end