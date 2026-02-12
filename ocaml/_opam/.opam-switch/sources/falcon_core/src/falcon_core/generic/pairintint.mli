open Ctypes

(** Opaque handle for PairIntInt *)
class type c_pairintint_t = object
  method raw : unit ptr
end

class c_pairintint : unit ptr -> c_pairintint_t

module PairIntInt : sig
  type t = c_pairintint

end

module PairIntInt : sig
  type t = c_pairintint

  val make : int -> int -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> int
  val second : t -> int
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end