open Ctypes

open Falcon_core.Physics.Config.Geometries

(** Opaque handle for ListDotGateWithNeighbors *)
class type c_listdotgatewithneighbors_t = object
  method raw : unit ptr
end

class c_listdotgatewithneighbors : unit ptr -> c_listdotgatewithneighbors_t

module ListDotGateWithNeighbors : sig
  type t = c_listdotgatewithneighbors

end

module ListDotGateWithNeighbors : sig
  type t = c_listdotgatewithneighbors

  val empty : t
  val copy : t -> t
  val fillValue : int -> DotGateWithNeighbors.t -> t
  val make : DotGateWithNeighbors.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> DotGateWithNeighbors.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> DotGateWithNeighbors.t
  val items : t -> DotGateWithNeighbors.t -> int -> int
  val contains : t -> DotGateWithNeighbors.t -> bool
  val index : t -> DotGateWithNeighbors.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end