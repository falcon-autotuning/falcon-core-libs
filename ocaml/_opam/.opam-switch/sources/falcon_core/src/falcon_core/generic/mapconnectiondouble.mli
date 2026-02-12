open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Device_structures

(** Opaque handle for MapConnectionDouble *)
class type c_mapconnectiondouble_t = object
  method raw : unit ptr
end

class c_mapconnectiondouble : unit ptr -> c_mapconnectiondouble_t

module MapConnectionDouble : sig
  type t = c_mapconnectiondouble

end

module MapConnectionDouble : sig
  type t = c_mapconnectiondouble

  val empty : t
  val copy : t -> t
  val make : PairConnectionDouble.t -> int -> t
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
  val values : t -> ListDouble.t
  val items : t -> ListPairConnectionDouble.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end