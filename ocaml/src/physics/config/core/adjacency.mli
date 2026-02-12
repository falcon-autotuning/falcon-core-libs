open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Adjacency *)
class type c_adjacency_t = object
  method raw : unit ptr
end

class c_adjacency : unit ptr -> c_adjacency_t

module Adjacency : sig
  type t = c_adjacency

  val copy : t -> t
  val fromjson : string -> t
  val make : int -> int -> int -> Connections.Connections.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val indexes : t -> Connections.Connections.t
  val getTruePairs : t -> Listpairsizetsizet.ListPairSizeTSizeT.t
  val size : t -> int
  val dimension : t -> int
  val shape : t -> int -> int -> int
  val data : t -> int -> int -> int
  val timesEqualsFarray : t -> Farrayint.FArrayInt.t -> unit
  val timesFarray : t -> Farrayint.FArrayInt.t -> t
  val sum : t -> int
  val where : t -> int -> Listlistsizet.ListListSizeT.t
  val flip : t -> int -> t
end