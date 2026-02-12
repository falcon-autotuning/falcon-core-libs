open Ctypes

(** Opaque handle for PairStringDouble *)
class type c_pairstringdouble_t = object
  method raw : unit ptr
end

class c_pairstringdouble : unit ptr -> c_pairstringdouble_t

module PairStringDouble : sig
  type t = c_pairstringdouble

end

module PairStringDouble : sig
  type t = c_pairstringdouble

  val make : string -> float -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> string
  val second : t -> float
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end