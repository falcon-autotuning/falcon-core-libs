open Ctypes

(** Opaque handle for PairSizeTSizeT *)
class type c_pairsizetsizet_t = object
  method raw : unit ptr
end

class c_pairsizetsizet : unit ptr -> c_pairsizetsizet_t

module PairSizeTSizeT : sig
  type t = c_pairsizetsizet

end

module PairSizeTSizeT : sig
  type t = c_pairsizetsizet

  val make : int -> int -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> int
  val second : t -> int
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end