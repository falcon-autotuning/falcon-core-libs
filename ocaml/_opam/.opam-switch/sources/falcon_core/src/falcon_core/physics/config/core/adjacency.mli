open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Device_structures

(** Opaque handle for Adjacency *)
class type c_adjacency_t = object
  method raw : unit ptr
end

class c_adjacency : unit ptr -> c_adjacency_t

module Adjacency : sig
  type t = c_adjacency

end

module Adjacency : sig
  type t = c_adjacency

  val copy : t -> t
  val fromjson : string -> t
  val make : int -> int -> int -> Connections.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val indexes : t -> Connections.t
  val getTruePairs : t -> ListPairSizeTSizeT.t
  val size : t -> int
  val dimension : t -> int
  val shape : t -> int -> int -> int
  val data : t -> int -> int -> int
  val timesEqualsFarray : t -> FArrayInt.t -> unit
  val timesFarray : t -> FArrayInt.t -> t
  val sum : t -> int
  val where : t -> int -> ListListSizeT.t
  val flip : t -> int -> t
end