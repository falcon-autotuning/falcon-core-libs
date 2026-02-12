open Ctypes

open Falcon_core.Generic
open Falcon_core.Physics.Config.Geometries

(** Opaque handle for DotGatesWithNeighbors *)
class type c_dotgateswithneighbors_t = object
  method raw : unit ptr
end

class c_dotgateswithneighbors : unit ptr -> c_dotgateswithneighbors_t

module DotGatesWithNeighbors : sig
  type t = c_dotgateswithneighbors

end

module DotGatesWithNeighbors : sig
  type t = c_dotgateswithneighbors

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : ListDotGateWithNeighbors.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val isPlungerGates : t -> bool
  val isBarrierGates : t -> bool
  val intersection : t -> t -> t
  val pushBack : t -> DotGateWithNeighbors.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> DotGateWithNeighbors.t
  val items : t -> ListDotGateWithNeighbors.t
  val contains : t -> DotGateWithNeighbors.t -> bool
  val index : t -> DotGateWithNeighbors.t -> int
end