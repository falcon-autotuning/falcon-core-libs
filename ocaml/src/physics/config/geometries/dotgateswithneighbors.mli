open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for DotGatesWithNeighbors *)
class type c_dotgateswithneighbors_t = object
  method raw : unit ptr
end

class c_dotgateswithneighbors : unit ptr -> c_dotgateswithneighbors_t

module DotGatesWithNeighbors : sig
  type t = c_dotgateswithneighbors

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : Listdotgatewithneighbors.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val isPlungerGates : t -> bool
  val isBarrierGates : t -> bool
  val intersection : t -> t -> t
  val pushBack : t -> Dotgatewithneighbors.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Dotgatewithneighbors.t
  val items : t -> Listdotgatewithneighbors.t
  val contains : t -> Dotgatewithneighbors.t -> bool
  val index : t -> Dotgatewithneighbors.t -> int
end