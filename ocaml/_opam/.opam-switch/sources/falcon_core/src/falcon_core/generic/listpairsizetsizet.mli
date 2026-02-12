open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairSizeTSizeT *)
class type c_listpairsizetsizet_t = object
  method raw : unit ptr
end

class c_listpairsizetsizet : unit ptr -> c_listpairsizetsizet_t

module ListPairSizeTSizeT : sig
  type t = c_listpairsizetsizet

end

module ListPairSizeTSizeT : sig
  type t = c_listpairsizetsizet

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairSizeTSizeT.t -> t
  val make : PairSizeTSizeT.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairSizeTSizeT.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairSizeTSizeT.t
  val items : t -> PairSizeTSizeT.t -> int -> int
  val contains : t -> PairSizeTSizeT.t -> bool
  val index : t -> PairSizeTSizeT.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end