open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math
open Falcon_core.Physics.Device_structures

(** Opaque handle for MapConnectionQuantity *)
class type c_mapconnectionquantity_t = object
  method raw : unit ptr
end

class c_mapconnectionquantity : unit ptr -> c_mapconnectionquantity_t

module MapConnectionQuantity : sig
  type t = c_mapconnectionquantity

end

module MapConnectionQuantity : sig
  type t = c_mapconnectionquantity

  val empty : t
  val copy : t -> t
  val make : PairConnectionQuantity.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Connection.t -> Quantity.t -> unit
  val insert : t -> Connection.t -> Quantity.t -> unit
  val at : t -> Connection.t -> Quantity.t
  val erase : t -> Connection.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Connection.t -> bool
  val keys : t -> ListConnection.t
  val values : t -> ListQuantity.t
  val items : t -> ListPairConnectionQuantity.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end