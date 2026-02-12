open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures

(** Opaque handle for GateRelations *)
class type c_gaterelations_t = object
  method raw : unit ptr
end

class c_gaterelations : unit ptr -> c_gaterelations_t

module GateRelations : sig
  type t = c_gaterelations

end

module GateRelations : sig
  type t = c_gaterelations

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : ListPairConnectionConnections.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val insertOrAssign : t -> Connection.t -> Connections.t -> unit
  val insert : t -> Connection.t -> Connections.t -> unit
  val at : t -> Connection.t -> Connections.t
  val erase : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.t -> bool
  val keys : t -> ListConnection.t
  val values : t -> ListConnections.t
  val items : t -> ListPairConnectionConnections.t
end