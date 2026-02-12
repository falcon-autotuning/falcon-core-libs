open Ctypes

open Falcon_core.Physics.Device_structures

(** Opaque handle for PairConnectionConnection *)
class type c_pairconnectionconnection_t = object
  method raw : unit ptr
end

class c_pairconnectionconnection : unit ptr -> c_pairconnectionconnection_t

module PairConnectionConnection : sig
  type t = c_pairconnectionconnection

end

module PairConnectionConnection : sig
  type t = c_pairconnectionconnection

  val make : Connection.t -> Connection.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Connection.t
  val second : t -> Connection.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end