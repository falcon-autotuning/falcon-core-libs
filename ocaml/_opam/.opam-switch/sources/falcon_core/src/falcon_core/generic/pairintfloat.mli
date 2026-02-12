open Ctypes

(** Opaque handle for PairIntFloat *)
class type c_pairintfloat_t = object
  method raw : unit ptr
end

class c_pairintfloat : unit ptr -> c_pairintfloat_t

module PairIntFloat : sig
  type t = c_pairintfloat

end

module PairIntFloat : sig
  type t = c_pairintfloat

  val make : int -> float -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> int
  val second : t -> float
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end