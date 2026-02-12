open Ctypes

open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures

(** Opaque handle for PairConnectionConnections *)
class type c_pairconnectionconnections_t = object
  method raw : unit ptr
end

class c_pairconnectionconnections : unit ptr -> c_pairconnectionconnections_t

module PairConnectionConnections : sig
  type t = c_pairconnectionconnections

end

module PairConnectionConnections : sig
  type t = c_pairconnectionconnections

  val make : Connection.t -> Connections.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Connection.t
  val second : t -> Connections.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end