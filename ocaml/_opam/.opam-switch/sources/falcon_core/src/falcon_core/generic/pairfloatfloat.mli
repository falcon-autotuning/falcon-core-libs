open Ctypes

(** Opaque handle for PairFloatFloat *)
class type c_pairfloatfloat_t = object
  method raw : unit ptr
end

class c_pairfloatfloat : unit ptr -> c_pairfloatfloat_t

module PairFloatFloat : sig
  type t = c_pairfloatfloat

end

module PairFloatFloat : sig
  type t = c_pairfloatfloat

  val make : float -> float -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> float
  val second : t -> float
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end