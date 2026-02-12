open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Device_structures

(** Opaque handle for MapConnectionFloat *)
class type c_mapconnectionfloat_t = object
  method raw : unit ptr
end

class c_mapconnectionfloat : unit ptr -> c_mapconnectionfloat_t

module MapConnectionFloat : sig
  type t = c_mapconnectionfloat

end

module MapConnectionFloat : sig
  type t = c_mapconnectionfloat

  val empty : t
  val copy : t -> t
  val make : PairConnectionFloat.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Connection.t -> float -> unit
  val insert : t -> Connection.t -> float -> unit
  val at : t -> Connection.t -> float
  val erase : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.t -> bool
  val keys : t -> ListConnection.t
  val values : t -> ListFloat.t
  val items : t -> ListPairConnectionFloat.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end