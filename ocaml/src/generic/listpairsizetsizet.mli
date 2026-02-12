open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairSizeTSizeT *)
class type c_listpairsizetsizet_t = object
  method raw : unit ptr
end

class c_listpairsizetsizet : unit ptr -> c_listpairsizetsizet_t

module ListPairSizeTSizeT : sig
  type t = c_listpairsizetsizet

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairsizetsizet.t -> t
  val make : Pairsizetsizet.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairsizetsizet.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairsizetsizet.t
  val items : t -> Pairsizetsizet.t -> int -> int
  val contains : t -> Pairsizetsizet.t -> bool
  val index : t -> Pairsizetsizet.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end